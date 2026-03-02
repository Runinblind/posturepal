//
//  SettingsViewModel.swift
//  PosturePal
//
//  Week 1 - Settings Screen Logic
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var selectedInterval: ReminderInterval
    @Published var quietHoursEnabled: Bool
    @Published var quietHoursStart: Date
    @Published var quietHoursEnd: Date
    @Published var watchNotificationsEnabled: Bool
    @Published var isPremium: Bool
    
    @Published var showIntervalPicker: Bool = false
    @Published var showResetConfirmation: Bool = false
    @Published var showPaywall: Bool = false
    
    private let settingsManager = SettingsManager.shared
    private let notificationService = NotificationService.shared
    
    init() {
        let settings = settingsManager.settings
        self.selectedInterval = settings.reminderInterval
        self.quietHoursEnabled = settings.quietHoursEnabled
        self.quietHoursStart = settings.quietHoursStart
        self.quietHoursEnd = settings.quietHoursEnd
        self.watchNotificationsEnabled = settings.watchNotificationsEnabled
        self.isPremium = settings.isPremium
    }
    
    // MARK: - Actions
    
    func updateInterval(_ interval: ReminderInterval) {
        // Check premium requirement
        if interval.isPremium && !isPremium {
            showPaywall = true
            return
        }
        
        selectedInterval = interval
        settingsManager.updateReminderInterval(interval)
        
        // Reschedule notifications with new interval
        rescheduleNotifications()
        
        print("⏰ Interval updated to: \(interval.displayName)")
    }
    
    func toggleQuietHours(_ enabled: Bool) {
        quietHoursEnabled = enabled
        settingsManager.toggleQuietHours(enabled)
        
        // Reschedule notifications respecting quiet hours
        rescheduleNotifications()
        
        print("🌙 Quiet hours: \(enabled ? "ON" : "OFF")")
    }
    
    func updateQuietHoursStart(_ time: Date) {
        quietHoursStart = time
        settingsManager.updateQuietHours(start: time, end: quietHoursEnd)
        rescheduleNotifications()
    }
    
    func updateQuietHoursEnd(_ time: Date) {
        quietHoursEnd = time
        settingsManager.updateQuietHours(start: quietHoursStart, end: time)
        rescheduleNotifications()
    }
    
    func toggleWatchNotifications(_ enabled: Bool) {
        watchNotificationsEnabled = enabled
        settingsManager.settings.watchNotificationsEnabled = enabled
        print("⌚ Watch notifications: \(enabled ? "ON" : "OFF")")
    }
    
    private func rescheduleNotifications() {
        let quietHours = QuietHoursConfig(
            enabled: quietHoursEnabled,
            startTime: quietHoursStart,
            endTime: quietHoursEnd
        )
        
        notificationService.scheduleNextReminder(
            interval: selectedInterval,
            quietHours: quietHours
        )
    }
    
    // MARK: - Premium
    
    func showUpgradeScreen() {
        showPaywall = true
    }
    
    func unlockPremium() {
        isPremium = true
        settingsManager.unlockPremium()
        print("🌟 Premium unlocked!")
    }
    
    // MARK: - Reset Streak
    
    func requestResetStreak() {
        showResetConfirmation = true
    }
    
    func confirmResetStreak(context: NSManagedObjectContext) {
        // Delete all check-ins
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CheckIn.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("🗑️ All check-ins deleted, streak reset")
            
            // Cancel pending notifications
            notificationService.cancelAllNotifications()
            
            // Reschedule fresh
            rescheduleNotifications()
            
        } catch {
            print("❌ Failed to reset streak: \(error)")
        }
        
        showResetConfirmation = false
    }
    
    // MARK: - Computed Properties
    
    var availableIntervals: [ReminderInterval] {
        ReminderInterval.allCases
    }
    
    var quietHoursTimeRange: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: quietHoursStart)) - \(formatter.string(from: quietHoursEnd))"
    }
}
