// AchievementsView.swift
// PosturePal Pro - Week 4-5
// Achievement showcase and sharing

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var manager = AchievementManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAchievement: Achievement?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Progress header
                    progressHeader
                    
                    // Unlocked achievements
                    achievementSection(
                        title: "Unlocked (\(manager.unlockedAchievements.count))",
                        achievements: manager.unlockedAchievements,
                        isLocked: false
                    )
                    
                    // Locked achievements
                    achievementSection(
                        title: "Locked (\(manager.lockedAchievements.count))",
                        achievements: manager.lockedAchievements,
                        isLocked: true
                    )
                }
                .padding()
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedAchievement) { achievement in
                AchievementDetailSheet(achievement: achievement)
            }
        }
    }
    
    // MARK: - Progress Header
    
    private var progressHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: manager.completionPercentage / 100)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(), value: manager.completionPercentage)
                
                VStack {
                    Text("\(Int(manager.completionPercentage))%")
                        .font(.system(size: 36, weight: .bold))
                    Text("Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 150, height: 150)
            
            Text("\(manager.unlockedAchievements.count) of \(manager.achievements.count) achievements")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    // MARK: - Achievement Section
    
    private func achievementSection(title: String, achievements: [Achievement], isLocked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(achievements) { achievement in
                    AchievementCard(achievement: achievement, isLocked: isLocked)
                        .onTapGesture {
                            selectedAchievement = achievement
                        }
                }
            }
        }
    }
}

// MARK: - Achievement Card

struct AchievementCard: View {
    let achievement: Achievement
    let isLocked: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: achievement.iconName)
                .font(.system(size: 40))
                .foregroundColor(isLocked ? .gray : achievement.iconColor)
                .opacity(isLocked ? 0.3 : 1.0)
            
            Text(achievement.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(isLocked ? .secondary : .primary)
            
            if isLocked {
                Text("\(achievement.requirement) \(requirement Text)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } else if let date = achievement.unlockedDate {
                Text(date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isLocked ? Color.gray.opacity(0.1) : achievement.iconColor.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isLocked ? Color.gray.opacity(0.2) : achievement.iconColor.opacity(0.3), lineWidth: 2)
        )
    }
    
    private var requirementText: String {
        switch achievement.category {
        case .streak:
            return achievement.requirement == 1 ? "day" : "days"
        case .checkIn:
            return "check-ins"
        case .consistency:
            return "days"
        case .special:
            return "time"
        }
    }
}

// MARK: - Achievement Detail Sheet

struct AchievementDetailSheet: View {
    let achievement: Achievement
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: achievement.iconName)
                    .font(.system(size: 80))
                    .foregroundColor(achievement.isUnlocked ? achievement.iconColor : .gray)
                    .opacity(achievement.isUnlocked ? 1.0 : 0.3)
                
                VStack(spacing: 8) {
                    Text(achievement.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(achievement.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                if achievement.isUnlocked, let date = achievement.unlockedDate {
                    Text("Unlocked on \(date.formatted(date: .long, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if achievement.isUnlocked {
                    Button(action: shareAchievement) {
                        Label("Share Achievement", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(achievement.iconColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .padding()
            .navigationTitle("Achievement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func shareAchievement() {
        let text = """
        🏆 Achievement Unlocked!
        
        \(achievement.title)
        \(achievement.description)
        
        PosturePal Pro - Building better posture habits
        """
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = rootViewController.view
            popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX,
                                      y: rootViewController.view.bounds.midY,
                                      width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        rootViewController.present(activityVC, animated: true)
    }
}

// MARK: - Preview

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
