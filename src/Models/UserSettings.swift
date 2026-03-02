//
//  UserSettings.swift
//  PosturePal
//
//  Week 1 - Core Data Model
//

import Foundation

// MARK: - User Settings Model

struct UserSettings: Codable, Equatable {
    var reminderInterval: ReminderInterval = .sixtyMinutes
    var quietHoursEnabled: Bool = true
    var quietHoursStart: Date = {
        var components = DateComponents()
        components.hour = 22
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    var quietHoursEnd: Date = {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    var notificationSound: NotificationSound = .gentle
    var hapticFeedback: Bool = true
    var hapticIntensity: HapticIntensity = .medium
    var isPremium: Bool = false
    var onboardingCompleted: Bool = false
    
    // Week 4-5: New settings
    var userName: String = ""
    var themeMode: ThemeMode = .auto
    
    // Watch settings
    var watchNotificationsEnabled: Bool = true
}

// MARK: - Reminder Interval

enum ReminderInterval: Int, Codable, CaseIterable, Identifiable {
    case fifteenMinutes = 15    // Premium only
    case thirtyMinutes = 30     // Premium only
    case fortyFiveMinutes = 45  // Premium only
    case sixtyMinutes = 60      // Free (default)
    case ninetyMinutes = 90     // Premium only
    
    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
        case .fifteenMinutes: return "15 minutes"
        case .thirtyMinutes: return "30 minutes"
        case .fortyFiveMinutes: return "45 minutes"
        case .sixtyMinutes: return "60 minutes"
        case .ninetyMinutes: return "90 minutes"
        }
    }
    
    var isPremium: Bool {
        self != .sixtyMinutes
    }
    
    var timeInterval: TimeInterval {
        TimeInterval(rawValue * 60)
    }
}

// MARK: - Notification Sound

enum NotificationSound: String, Codable, CaseIterable, Identifiable {
    case gentle = "gentle"
    case chime = "chime"
    case bell = "bell"
    case ding = "ding"
    case swoosh = "swoosh"
    case ping = "ping"
    case tone = "tone"
    case alert = "alert"
    case silent = "silent"
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
}

// MARK: - Haptic Intensity

enum HapticIntensity: String, Codable, CaseIterable, Identifiable {
    case light = "light"
    case medium = "medium"
    case strong = "strong"
    case off = "off"
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue.capitalized
    }
}

// MARK: - Theme Mode

enum ThemeMode: String, Codable, CaseIterable, Identifiable {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .auto: return "Automatic"
        }
    }
}

// MARK: - Settings Manager (Singleton)

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var settings: UserSettings {
        didSet {
            saveSettings()
        }
    }
    
    private let userDefaultsKey = "user_settings"
    
    private init() {
        // Load settings from UserDefaults
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = UserSettings()
        }
    }
    
    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            print("💾 Settings saved")
        }
    }
    
    // MARK: - Helpers
    
    func completeOnboarding() {
        settings.onboardingCompleted = true
    }
    
    func updateReminderInterval(_ interval: ReminderInterval) {
        guard !interval.isPremium || settings.isPremium else {
            print("⚠️ Premium interval requires subscription")
            return
        }
        settings.reminderInterval = interval
    }
    
    func toggleQuietHours(_ enabled: Bool) {
        settings.quietHoursEnabled = enabled
    }
    
    func updateQuietHours(start: Date, end: Date) {
        settings.quietHoursStart = start
        settings.quietHoursEnd = end
    }
    
    func unlockPremium() {
        settings.isPremium = true
        print("🌟 Premium unlocked!")
    }
}
