//
//  NotificationService.swift
//  PosturePal
//
//  Week 1 - Local Notification Scheduling & Management
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationService: NSObject, ObservableObject {
    static let shared = NotificationService()
    
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    private let center = UNUserNotificationCenter.current()
    private let notificationIdentifier = "posture_reminder"
    
    override init() {
        super.init()
        center.delegate = self
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Notification auth error: \(error)")
                }
                self.authorizationStatus = granted ? .authorized : .denied
                completion(granted)
            }
        }
    }
    
    func checkAuthorizationStatus() {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    // MARK: - Scheduling
    
    func scheduleNextReminder(
        interval: ReminderInterval,
        quietHours: QuietHoursConfig? = nil
    ) {
        // Remove any pending notifications first
        cancelAllNotifications()
        
        // Calculate next notification time
        var nextTime = Date().addingTimeInterval(interval.timeInterval)
        
        // Check quiet hours
        if let qh = quietHours, qh.enabled, qh.isInQuietHours(nextTime) {
            nextTime = qh.nextActiveTime(after: nextTime)
        }
        
        let timeInterval = nextTime.timeIntervalSinceNow
        
        guard timeInterval > 0 else {
            print("⚠️ Invalid time interval for notification")
            return
        }
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Posture Check 🧘"
        content.body = "Time to check your posture!"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "POSTURE_CHECK"
        
        // Add user info for tracking
        content.userInfo = [
            "scheduled_time": nextTime.timeIntervalSince1970,
            "interval": interval.rawValue
        ]
        
        // Create trigger
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )
        
        // Create request
        let request = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: content,
            trigger: trigger
        )
        
        // Schedule
        center.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("✅ Notification scheduled for: \(nextTime)")
            }
        }
    }
    
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("🗑️ All notifications cancelled")
    }
    
    // MARK: - Notification Actions
    
    func registerNotificationActions() {
        // "Check In" action
        let checkInAction = UNNotificationAction(
            identifier: "CHECK_IN_ACTION",
            title: "Check In",
            options: [.foreground]
        )
        
        // "Snooze" action
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_ACTION",
            title: "Snooze 10 min",
            options: []
        )
        
        // Category
        let category = UNNotificationCategory(
            identifier: "POSTURE_CHECK",
            actions: [checkInAction, snoozeAction],
            intentIdentifiers: [],
            options: []
        )
        
        center.setNotificationCategories([category])
        print("✅ Notification actions registered")
    }
    
    // MARK: - Helpers
    
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        center.getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    // Handle notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is open
        completionHandler([.banner, .sound, .badge])
    }
    
    // Handle notification tap
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let actionIdentifier = response.actionIdentifier
        
        switch actionIdentifier {
        case "CHECK_IN_ACTION":
            print("✅ User tapped Check In from notification")
            // Handle check-in (will be implemented in DataService)
            NotificationCenter.default.post(name: .checkInFromNotification, object: nil)
            
        case "SNOOZE_ACTION":
            print("⏰ User snoozed notification")
            // Reschedule in 10 minutes
            scheduleSnooze(minutes: 10)
            
        default:
            // Default tap (opens app)
            print("📱 User opened app from notification")
        }
        
        completionHandler()
    }
    
    private func scheduleSnooze(minutes: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Posture Check 🧘"
        content.body = "Snooze is over! Time to check your posture."
        content.sound = .default
        content.categoryIdentifier = "POSTURE_CHECK"
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(minutes * 60),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "snooze_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        center.add(request)
    }
}

// MARK: - Quiet Hours Configuration

struct QuietHoursConfig {
    var enabled: Bool
    var startTime: Date
    var endTime: Date
    
    func isInQuietHours(_ date: Date) -> Bool {
        guard enabled else { return false }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let startHour = calendar.component(.hour, from: startTime)
        let endHour = calendar.component(.hour, from: endTime)
        
        // Handle wrap-around (e.g., 22:00 to 08:00)
        if startHour > endHour {
            return hour >= startHour || hour < endHour
        } else {
            return hour >= startHour && hour < endHour
        }
    }
    
    func nextActiveTime(after date: Date) -> Date {
        guard enabled else { return date }
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: endTime)
        
        // Set to today's end time
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: date)
        components.year = todayComponents.year
        components.month = todayComponents.month
        components.day = todayComponents.day
        
        guard let endToday = calendar.date(from: components) else {
            return date
        }
        
        // If we're past end time today, use today's end time
        // Otherwise, use tomorrow's end time
        if date < endToday {
            return endToday
        } else {
            return calendar.date(byAdding: .day, value: 1, to: endToday) ?? date
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let checkInFromNotification = Notification.Name("checkInFromNotification")
}
