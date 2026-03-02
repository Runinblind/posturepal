//
//  WatchConnectivityManager.swift
//  PosturePal Watch App
//
//  Handles bidirectional sync between Apple Watch and iPhone
//  Uses WatchConnectivity framework for message passing and data sync
//

import Foundation
import WatchConnectivity
import Combine

/// Manages WatchConnectivity session and data synchronization
class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    // MARK: - Published Properties
    
    @Published var isReachable: Bool = false
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var lastCheckInDate: Date?
    @Published var nextReminderTime: Date?
    @Published var todayCheckIns: Int = 0
    
    // MARK: - Private Properties
    
    private let session: WCSession
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    private override init() {
        self.session = WCSession.default
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Activate the WatchConnectivity session
    func activate() {
        guard WCSession.isSupported() else {
            print("⌚️ WatchConnectivity not supported on this device")
            return
        }
        
        session.delegate = self
        session.activate()
        print("⌚️ WatchConnectivity session activated")
    }
    
    /// Request current streak data from iPhone
    func requestStreakData() {
        guard session.isReachable else {
            print("⌚️ iPhone not reachable, using cached data")
            loadCachedData()
            return
        }
        
        let message: [String: Any] = ["action": "getStreakData"]
        
        session.sendMessage(message, replyHandler: { [weak self] reply in
            DispatchQueue.main.async {
                self?.handleStreakDataReply(reply)
            }
        }) { error in
            print("⌚️ Error requesting streak data: \(error.localizedDescription)")
        }
    }
    
    /// Send a check-in to the iPhone
    /// - Parameter timestamp: When the check-in occurred
    func sendCheckIn(timestamp: Date = Date()) {
        let checkInData: [String: Any] = [
            "action": "checkIn",
            "timestamp": timestamp.timeIntervalSince1970
        ]
        
        if session.isReachable {
            // iPhone reachable - send immediately
            session.sendMessage(checkInData, replyHandler: { [weak self] reply in
                DispatchQueue.main.async {
                    self?.handleCheckInReply(reply)
                }
            }) { error in
                print("⌚️ Error sending check-in: \(error.localizedDescription)")
                // Fallback to transferUserInfo for store-and-forward
                self.session.transferUserInfo(checkInData)
            }
        } else {
            // iPhone not reachable - use store-and-forward
            print("⌚️ iPhone not reachable, queuing check-in for sync")
            session.transferUserInfo(checkInData)
            
            // Update local state optimistically
            todayCheckIns += 1
            lastCheckInDate = timestamp
            
            // Cache locally
            cacheCheckIn(timestamp)
        }
    }
    
    // MARK: - Private Methods
    
    /// Handle streak data reply from iPhone
    private func handleStreakDataReply(_ reply: [String: Any]) {
        currentStreak = reply["currentStreak"] as? Int ?? 0
        longestStreak = reply["longestStreak"] as? Int ?? 0
        todayCheckIns = reply["todayCheckIns"] as? Int ?? 0
        
        if let lastCheckInTimestamp = reply["lastCheckIn"] as? TimeInterval {
            lastCheckInDate = Date(timeIntervalSince1970: lastCheckInTimestamp)
        }
        
        if let nextReminderTimestamp = reply["nextReminder"] as? TimeInterval {
            nextReminderTime = Date(timeIntervalSince1970: nextReminderTimestamp)
        }
        
        // Cache for offline use
        cacheStreakData()
        
        print("⌚️ Received streak data - current: \(currentStreak), today: \(todayCheckIns)")
    }
    
    /// Handle check-in confirmation reply
    private func handleCheckInReply(_ reply: [String: Any]) {
        if let success = reply["success"] as? Bool, success {
            currentStreak = reply["newStreak"] as? Int ?? currentStreak
            todayCheckIns = reply["todayCheckIns"] as? Int ?? todayCheckIns
            
            if let nextReminderTimestamp = reply["nextReminder"] as? TimeInterval {
                nextReminderTime = Date(timeIntervalSince1970: nextReminderTimestamp)
            }
            
            print("⌚️ Check-in confirmed - new streak: \(currentStreak)")
            
            // Haptic feedback
            WKInterfaceDevice.current().play(.success)
        }
    }
    
    /// Cache streak data locally for offline use
    private func cacheStreakData() {
        UserDefaults.standard.set(currentStreak, forKey: "cachedCurrentStreak")
        UserDefaults.standard.set(longestStreak, forKey: "cachedLongestStreak")
        UserDefaults.standard.set(todayCheckIns, forKey: "cachedTodayCheckIns")
        
        if let lastCheckIn = lastCheckInDate {
            UserDefaults.standard.set(lastCheckIn, forKey: "cachedLastCheckIn")
        }
        
        if let nextReminder = nextReminderTime {
            UserDefaults.standard.set(nextReminder, forKey: "cachedNextReminder")
        }
    }
    
    /// Load cached data when iPhone is unreachable
    private func loadCachedData() {
        currentStreak = UserDefaults.standard.integer(forKey: "cachedCurrentStreak")
        longestStreak = UserDefaults.standard.integer(forKey: "cachedLongestStreak")
        todayCheckIns = UserDefaults.standard.integer(forKey: "cachedTodayCheckIns")
        lastCheckInDate = UserDefaults.standard.object(forKey: "cachedLastCheckIn") as? Date
        nextReminderTime = UserDefaults.standard.object(forKey: "cachedNextReminder") as? Date
        
        print("⌚️ Loaded cached data - streak: \(currentStreak)")
    }
    
    /// Cache a check-in locally for later sync
    private func cacheCheckIn(_ timestamp: Date) {
        var pendingCheckIns = UserDefaults.standard.array(forKey: "pendingCheckIns") as? [TimeInterval] ?? []
        pendingCheckIns.append(timestamp.timeIntervalSince1970)
        UserDefaults.standard.set(pendingCheckIns, forKey: "pendingCheckIns")
    }
    
    /// Sync any pending check-ins when connection is established
    private func syncPendingCheckIns() {
        guard let pendingCheckIns = UserDefaults.standard.array(forKey: "pendingCheckIns") as? [TimeInterval],
              !pendingCheckIns.isEmpty else {
            return
        }
        
        print("⌚️ Syncing \(pendingCheckIns.count) pending check-ins")
        
        for timestamp in pendingCheckIns {
            let checkInData: [String: Any] = [
                "action": "checkIn",
                "timestamp": timestamp
            ]
            session.transferUserInfo(checkInData)
        }
        
        // Clear pending after sending
        UserDefaults.standard.removeObject(forKey: "pendingCheckIns")
    }
}

// MARK: - WCSessionDelegate

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("⌚️ WCSession activation failed: \(error.localizedDescription)")
                return
            }
            
            print("⌚️ WCSession activated with state: \(activationState.rawValue)")
            
            // Request initial data
            self.requestStreakData()
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
            print("⌚️ iPhone reachability changed: \(session.isReachable)")
            
            if session.isReachable {
                // Connection established - sync pending check-ins
                self.syncPendingCheckIns()
                
                // Refresh streak data
                self.requestStreakData()
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            guard let action = message["action"] as? String else { return }
            
            switch action {
            case "streakUpdated":
                // iPhone proactively sent updated streak data
                self.handleStreakDataReply(message)
                
            case "reminderScheduled":
                // New reminder scheduled on iPhone
                if let nextReminderTimestamp = message["nextReminder"] as? TimeInterval {
                    self.nextReminderTime = Date(timeIntervalSince1970: nextReminderTimestamp)
                }
                
            default:
                print("⌚️ Unknown message action: \(action)")
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            // Handle background data transfer completion
            print("⌚️ Received userInfo transfer")
            
            if let action = userInfo["action"] as? String, action == "streakUpdated" {
                self.handleStreakDataReply(userInfo)
            }
        }
    }
}
