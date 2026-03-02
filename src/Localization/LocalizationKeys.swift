// LocalizationKeys.swift
// PosturePal Pro - Week 4-5
// Localization string keys and helpers

import Foundation

/// Centralized localization keys
enum LocalizationKey: String {
    // MARK: - General
    case appName = "app_name"
    case ok = "ok"
    case cancel = "cancel"
    case done = "done"
    case save = "save"
    case delete = "delete"
    case edit = "edit"
    case continue_ = "continue"
    
    // MARK: - Onboarding
    case onboardingWelcomeTitle = "onboarding_welcome_title"
    case onboardingWelcomeDescription = "onboarding_welcome_description"
    case onboardingNotificationsTitle = "onboarding_notifications_title"
    case onboardingNotificationsDescription = "onboarding_notifications_description"
    case onboardingGetStarted = "onboarding_get_started"
    
    // MARK: - Dashboard
    case dashboardTitle = "dashboard_title"
    case currentStreak = "current_streak"
    case longestStreak = "longest_streak"
    case checkInToday = "check_in_today"
    case checkInButton = "check_in_button"
    case greatWork = "great_work"
    
    // MARK: - Streaks
    case dayStreak = "day_streak"
    case days = "days"
    case day = "day"
    case streakMilestone = "streak_milestone"
    
    // MARK: - Settings
    case settingsTitle = "settings_title"
    case reminderInterval = "reminder_interval"
    case notificationSound = "notification_sound"
    case quietHours = "quiet_hours"
    case hapticFeedback = "haptic_feedback"
    case premium = "premium"
    
    // MARK: - Notifications
    case notificationTitle = "notification_title"
    case notificationBody = "notification_body"
    case checkInAction = "check_in_action"
    case snoozeAction = "snooze_action"
    
    // MARK: - Achievements
    case achievementsTitle = "achievements_title"
    case achievementUnlocked = "achievement_unlocked"
    case shareAchievement = "share_achievement"
    
    // MARK: - Analytics
    case analyticsTitle = "analytics_title"
    case totalCheckIns = "total_check_ins"
    case complianceRate = "compliance_rate"
    case averagePerDay = "average_per_day"
    case exportData = "export_data"
    
    // MARK: - Errors
    case errorGeneric = "error_generic"
    case errorNotifications = "error_notifications"
    case errorLoadingData = "error_loading_data"
    
    /// Get localized string
    var localized: String {
        NSLocalizedString(rawValue, comment: "")
    }
    
    /// Get localized string with arguments
    func localized(with arguments: CVarArg...) -> String {
        String(format: localized, arguments: arguments)
    }
}

// MARK: - String Extension for Localization

extension String {
    /// Convenience method for localization
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    /// Localize with arguments
    func localized(with arguments: CVarArg...) -> String {
        String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}

// MARK: - Localizable Strings (English - Base)

/// This would be in Localizable.strings file:
/**
 
 // General
 "app_name" = "PosturePal Pro";
 "ok" = "OK";
 "cancel" = "Cancel";
 "done" = "Done";
 "save" = "Save";
 "delete" = "Delete";
 "edit" = "Edit";
 "continue" = "Continue";
 
 // Onboarding
 "onboarding_welcome_title" = "Welcome to PosturePal";
 "onboarding_welcome_description" = "Build better posture habits with gentle reminders";
 "onboarding_notifications_title" = "Enable Notifications";
 "onboarding_notifications_description" = "Get reminders throughout your day";
 "onboarding_get_started" = "Get Started";
 
 // Dashboard
 "dashboard_title" = "Dashboard";
 "current_streak" = "Current Streak";
 "longest_streak" = "Longest Streak";
 "check_in_today" = "Check in today";
 "check_in_button" = "Check In";
 "great_work" = "Great work! 🎉";
 
 // Streaks
 "day_streak" = "Day Streak";
 "days" = "days";
 "day" = "day";
 "streak_milestone" = "🎉 %d day milestone!";
 
 // Settings
 "settings_title" = "Settings";
 "reminder_interval" = "Reminder Interval";
 "notification_sound" = "Notification Sound";
 "quiet_hours" = "Quiet Hours";
 "haptic_feedback" = "Haptic Feedback";
 "premium" = "Premium";
 
 // Notifications
 "notification_title" = "Posture Check! 🧘";
 "notification_body" = "Take a moment to check your posture";
 "check_in_action" = "Check In";
 "snooze_action" = "Snooze 10min";
 
 // Achievements
 "achievements_title" = "Achievements";
 "achievement_unlocked" = "Achievement Unlocked!";
 "share_achievement" = "Share Achievement";
 
 // Analytics
 "analytics_title" = "Analytics";
 "total_check_ins" = "Total Check-Ins";
 "compliance_rate" = "Compliance Rate";
 "average_per_day" = "Avg Per Day";
 "export_data" = "Export Data";
 
 // Errors
 "error_generic" = "Something went wrong. Please try again.";
 "error_notifications" = "Failed to schedule notification";
 "error_loading_data" = "Failed to load data";
 
 */
