// Achievement.swift
// PosturePal Pro - Week 4-5
// Achievement system for streaks and milestones

import Foundation
import SwiftUI

/// Achievement earned by the user
struct Achievement: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let requirement: Int // Days or check-ins required
    let category: AchievementCategory
    var unlockedDate: Date?
    
    var isUnlocked: Bool {
        unlockedDate != nil
    }
    
    enum AchievementCategory: String, Codable {
        case streak
        case checkIn
        case consistency
        case special
    }
    
    /// Default achievements available in the app
    static let allAchievements: [Achievement] = [
        // Streak achievements
        Achievement(
            id: "streak_7",
            title: "Week Warrior",
            description: "Complete a 7-day streak",
            iconName: "7.circle.fill",
            requirement: 7,
            category: .streak
        ),
        Achievement(
            id: "streak_14",
            title: "Fortnight Focus",
            description: "Complete a 14-day streak",
            iconName: "14.circle.fill",
            requirement: 14,
            category: .streak
        ),
        Achievement(
            id: "streak_30",
            title: "Monthly Master",
            description: "Complete a 30-day streak",
            iconName: "30.circle.fill",
            requirement: 30,
            category: .streak
        ),
        Achievement(
            id: "streak_60",
            title: "Two-Month Champion",
            description: "Complete a 60-day streak",
            iconName: "60.circle.fill",
            requirement: 60,
            category: .streak
        ),
        Achievement(
            id: "streak_100",
            title: "Century Club",
            description: "Complete a 100-day streak",
            iconName: "100.circle.fill",
            requirement: 100,
            category: .streak
        ),
        Achievement(
            id: "streak_365",
            title: "Year of Posture",
            description: "Complete a 365-day streak",
            iconName: "365.circle.fill",
            requirement: 365,
            category: .streak
        ),
        
        // Check-in achievements
        Achievement(
            id: "checkin_50",
            title: "Half Century",
            description: "Complete 50 check-ins",
            iconName: "50.square.fill",
            requirement: 50,
            category: .checkIn
        ),
        Achievement(
            id: "checkin_100",
            title: "Centurion",
            description: "Complete 100 check-ins",
            iconName: "100.square.fill",
            requirement: 100,
            category: .checkIn
        ),
        Achievement(
            id: "checkin_500",
            title: "Posture Pro",
            description: "Complete 500 check-ins",
            iconName: "star.fill",
            requirement: 500,
            category: .checkIn
        ),
        Achievement(
            id: "checkin_1000",
            title: "Legend",
            description: "Complete 1000 check-ins",
            iconName: "crown.fill",
            requirement: 1000,
            category: .checkIn
        ),
        
        // Consistency achievements
        Achievement(
            id: "perfect_week",
            title: "Perfect Week",
            description: "Check in every day for a week",
            iconName: "checkmark.circle.fill",
            requirement: 7,
            category: .consistency
        ),
        Achievement(
            id: "perfect_month",
            title: "Perfect Month",
            description: "Check in every day for a month",
            iconName: "checkmark.seal.fill",
            requirement: 30,
            category: .consistency
        ),
        
        // Special achievements
        Achievement(
            id: "early_bird",
            title: "Early Bird",
            description: "Check in before 8 AM",
            iconName: "sunrise.fill",
            requirement: 1,
            category: .special
        ),
        Achievement(
            id: "night_owl",
            title: "Night Owl",
            description: "Check in after 10 PM",
            iconName: "moon.stars.fill",
            requirement: 1,
            category: .special
        )
    ]
    
    /// Get achievement icon color
    var iconColor: Color {
        switch category {
        case .streak:
            return .orange
        case .checkIn:
            return .blue
        case .consistency:
            return .green
        case .special:
            return .purple
        }
    }
}

/// Manager for tracking and unlocking achievements
class AchievementManager: ObservableObject {
    static let shared = AchievementManager()
    
    @Published private(set) var achievements: [Achievement]
    private let saveKey = "user_achievements"
    
    private init() {
        // Load saved achievements or initialize defaults
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let saved = try? JSONDecoder().decode([Achievement].self, from: data) {
            self.achievements = saved
        } else {
            self.achievements = Achievement.allAchievements
            save()
        }
    }
    
    /// Check and unlock achievements based on current stats
    func checkAchievements(streak: StreakData, checkIns: [CheckIn]) -> [Achievement] {
        var newlyUnlocked: [Achievement] = []
        
        for index in achievements.indices {
            guard !achievements[index].isUnlocked else { continue }
            
            var shouldUnlock = false
            
            switch achievements[index].category {
            case .streak:
                shouldUnlock = streak.currentStreak >= achievements[index].requirement ||
                              streak.longestStreak >= achievements[index].requirement
                
            case .checkIn:
                shouldUnlock = checkIns.count >= achievements[index].requirement
                
            case .consistency:
                // Perfect streak means current streak equals requirement
                shouldUnlock = streak.currentStreak >= achievements[index].requirement
                
            case .special:
                // Check special achievements
                if achievements[index].id == "early_bird" {
                    shouldUnlock = checkIns.contains { Calendar.current.component(.hour, from: $0.timestamp) < 8 }
                } else if achievements[index].id == "night_owl" {
                    shouldUnlock = checkIns.contains { Calendar.current.component(.hour, from: $0.timestamp) >= 22 }
                }
            }
            
            if shouldUnlock {
                achievements[index].unlockedDate = Date()
                newlyUnlocked.append(achievements[index])
            }
        }
        
        if !newlyUnlocked.isEmpty {
            save()
        }
        
        return newlyUnlocked
    }
    
    /// Get unlocked achievements
    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }
    
    /// Get locked achievements
    var lockedAchievements: [Achievement] {
        achievements.filter { !$0.isUnlocked }
    }
    
    /// Progress percentage (0-100)
    var completionPercentage: Double {
        let unlocked = Double(unlockedAchievements.count)
        let total = Double(achievements.count)
        return total > 0 ? (unlocked / total) * 100 : 0
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    
    /// Reset all achievements (for testing or user request)
    func resetAll() {
        achievements = Achievement.allAchievements
        save()
    }
}
