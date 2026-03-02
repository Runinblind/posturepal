//
//  DashboardViewModel.swift
//  PosturePal
//
//  Week 1 - Dashboard Screen Logic
//

import Foundation
import CoreData
import Combine
import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var streakData: StreakData = .empty
    @Published var todayCheckIns: [CheckIn] = []
    @Published var isLoading: Bool = false
    @Published var showCelebration: Bool = false
    @Published var celebrationMilestone: Int? = nil
    
    private let context: NSManagedObjectContext
    private let streakCalculator = StreakCalculator.shared
    private let notificationService = NotificationService.shared
    private let settingsManager = SettingsManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        // Listen for check-in notifications
        NotificationCenter.default.publisher(for: .checkInFromNotification)
            .sink { [weak self] _ in
                self?.performCheckIn()
            }
            .store(in: &cancellables)
        
        loadData()
    }
    
    // MARK: - Data Loading
    
    func loadData() {
        isLoading = true
        
        // Fetch all check-ins
        let allCheckIns = CheckIn.fetchAll(in: context)
        
        // Calculate streak data
        streakData = streakCalculator.calculateStreakData(from: allCheckIns)
        
        // Fetch today's check-ins
        todayCheckIns = CheckIn.fetchForDate(Date(), in: context)
        
        isLoading = false
        
        print("📊 Dashboard loaded: \(streakData.currentStreak) day streak, \(todayCheckIns.count) check-ins today")
    }
    
    func refresh() {
        loadData()
    }
    
    // MARK: - Check-In Action
    
    func performCheckIn() {
        let previousStreak = streakData.currentStreak
        
        // Create new check-in
        let checkIn = CheckIn.create(in: context, wasOnTime: true)
        
        // Save
        do {
            try context.save()
            print("✅ Check-in saved")
            
            // Reload data
            loadData()
            
            // Check for milestone
            if let milestone = streakCalculator.checkMilestone(previousStreak: previousStreak, newStreak: streakData.currentStreak) {
                celebrateMilestone(milestone)
            }
            
            // Reschedule next notification
            rescheduleNotification()
            
            // Haptic feedback
            triggerHapticFeedback()
            
        } catch {
            print("❌ Failed to save check-in: \(error)")
        }
    }
    
    private func rescheduleNotification() {
        let settings = settingsManager.settings
        
        let quietHours = QuietHoursConfig(
            enabled: settings.quietHoursEnabled,
            startTime: settings.quietHoursStart,
            endTime: settings.quietHoursEnd
        )
        
        notificationService.scheduleNextReminder(
            interval: settings.reminderInterval,
            quietHours: quietHours
        )
    }
    
    private func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // MARK: - Celebration
    
    private func celebrateMilestone(_ milestone: Int) {
        celebrationMilestone = milestone
        showCelebration = true
        
        // Custom haptic pattern for milestones
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            generator.notificationOccurred(.success)
        }
        
        print("🎉 Milestone reached: \(milestone) days!")
    }
    
    func dismissCelebration() {
        showCelebration = false
        celebrationMilestone = nil
    }
    
    // MARK: - Computed Properties
    
    var nextReminderTime: Date? {
        // This will be implemented when we add notification tracking
        // For now, return estimated time based on interval
        let interval = settingsManager.settings.reminderInterval
        return Date().addingTimeInterval(interval.timeInterval)
    }
    
    var todayProgress: String {
        let expectedCheckIns = expectedCheckInsToday()
        let actual = todayCheckIns.count
        return "\(actual)/\(expectedCheckIns)"
    }
    
    private func expectedCheckInsToday() -> Int {
        // Calculate how many reminders should have fired today
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let elapsed = now.timeIntervalSince(startOfDay)
        let interval = settingsManager.settings.reminderInterval.timeInterval
        
        return max(1, Int(elapsed / interval))
    }
}
