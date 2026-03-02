//
//  PhoneConnectivityManager.swift
//  PosturePal Pro (iPhone)
//
//  iPhone-side WatchConnectivity handler
//  Responds to Watch app requests and sends updates
//

import Foundation
import WatchConnectivity
import Combine

/// Manages WatchConnectivity from iPhone side
class PhoneConnectivityManager: NSObject, ObservableObject {
    static let shared = PhoneConnectivityManager()
    
    @Published var isPaired: Bool = false
    @Published var isWatchAppInstalled: Bool = false
    
    private let session: WCSession
    private var cancellables = Set<AnyCancellable>()
    
    private override init() {
        self.session = WCSession.default
        super.init()
    }
    
    /// Activate WatchConnectivity session
    func activate() {
        guard WCSession.isSupported() else {
            print("📱 WatchConnectivity not supported")
            return
        }
        
        session.delegate = self
        session.activate()
        print("📱 WatchConnectivity activated")
    }
    
    /// Send updated streak data to Watch
    func sendStreakUpdate() {
        guard session.isPaired && session.isWatchAppInstalled else {
            print("📱 Watch not paired or app not installed")
            return
        }
        
        let streakData = buildStreakData()
        
        if session.isReachable {
            // Send immediately if reachable
            session.sendMessage(streakData, replyHandler: nil) { error in
                print("📱 Error sending streak update: \(error.localizedDescription)")
            }
        } else {
            // Use background transfer if not reachable
            session.transferUserInfo(streakData)
        }
        
        print("📱 Sent streak update to Watch")
    }
    
    /// Build streak data dictionary for Watch
    private func buildStreakData() -> [String: Any] {
        let streakCalculator = StreakCalculator()
        let checkIns = fetchRecentCheckIns()
        let streakData = streakCalculator.calculate(from: checkIns)
        
        var data: [String: Any] = [
            "action": "streakUpdated",
            "currentStreak": streakData.currentStreak,
            "longestStreak": streakData.longestStreak,
            "todayCheckIns": streakCalculator.todayCheckInCount(from: checkIns)
        ]
        
        if let lastCheckIn = streakData.lastCheckInDate {
            data["lastCheckIn"] = lastCheckIn.timeIntervalSince1970
        }
        
        if let nextReminder = NotificationService.shared.nextScheduledNotification {
            data["nextReminder"] = nextReminder.timeIntervalSince1970
        }
        
        return data
    }
    
    /// Fetch recent check-ins from Core Data
    private func fetchRecentCheckIns() -> [CheckIn] {
        let context = PersistenceController.shared.container.viewContext
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        
        let request = CheckIn.fetchRequest()
        request.predicate = NSPredicate(format: "timestamp >= %@", thirtyDaysAgo as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CheckIn.timestamp, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("📱 Error fetching check-ins: \(error)")
            return []
        }
    }
    
    /// Handle check-in from Watch
    private func handleWatchCheckIn(timestamp: TimeInterval) -> [String: Any] {
        let checkInDate = Date(timeIntervalSince1970: timestamp)
        
        // Save check-in to Core Data
        let context = PersistenceController.shared.container.viewContext
        let checkIn = CheckIn(context: context)
        checkIn.id = UUID()
        checkIn.timestamp = checkInDate
        checkIn.wasOnTime = true // Assume on-time from Watch
        
        do {
            try context.save()
            print("📱 Saved check-in from Watch: \(checkInDate)")
            
            // Reschedule notification
            NotificationService.shared.scheduleNextNotification()
            
            // Calculate new streak
            let allCheckIns = fetchRecentCheckIns()
            let streakCalculator = StreakCalculator()
            let streakData = streakCalculator.calculate(from: allCheckIns)
            
            // Reply with updated data
            var reply: [String: Any] = [
                "success": true,
                "newStreak": streakData.currentStreak,
                "todayCheckIns": streakCalculator.todayCheckInCount(from: allCheckIns)
            ]
            
            if let nextReminder = NotificationService.shared.nextScheduledNotification {
                reply["nextReminder"] = nextReminder.timeIntervalSince1970
            }
            
            // Update widget data
            updateWidgetData(streakData: streakData, checkIns: allCheckIns)
            
            return reply
            
        } catch {
            print("📱 Error saving check-in: \(error)")
            return ["success": false, "error": error.localizedDescription]
        }
    }
    
    /// Update shared data for widgets
    private func updateWidgetData(streakData: StreakData, checkIns: [CheckIn]) {
        let sharedDefaults = UserDefaults(suiteName: "group.com.posturepal.app")
        sharedDefaults?.set(streakData.currentStreak, forKey: "widgetCurrentStreak")
        sharedDefaults?.set(StreakCalculator().todayCheckInCount(from: checkIns), forKey: "widgetTodayCheckIns")
        
        if let nextReminder = NotificationService.shared.nextScheduledNotification {
            sharedDefaults?.set(nextReminder, forKey: "widgetNextReminder")
        }
        
        print("📱 Updated widget data")
    }
}

// MARK: - WCSessionDelegate

extension PhoneConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("📱 WCSession activation failed: \(error.localizedDescription)")
                return
            }
            
            self.isPaired = session.isPaired
            self.isWatchAppInstalled = session.isWatchAppInstalled
            
            print("📱 WCSession activated - Paired: \(session.isPaired), App installed: \(session.isWatchAppInstalled)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("📱 WCSession became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("📱 WCSession deactivated")
        session.activate()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("📱 Watch reachability changed: \(session.isReachable)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            guard let action = message["action"] as? String else {
                replyHandler(["error": "No action specified"])
                return
            }
            
            switch action {
            case "getStreakData":
                // Watch requesting current streak data
                let data = self.buildStreakData()
                replyHandler(data)
                
            case "checkIn":
                // Watch sending a check-in
                let timestamp = message["timestamp"] as? TimeInterval ?? Date().timeIntervalSince1970
                let reply = self.handleWatchCheckIn(timestamp: timestamp)
                replyHandler(reply)
                
            default:
                print("📱 Unknown message action: \(action)")
                replyHandler(["error": "Unknown action"])
            }
        }
    }
}
