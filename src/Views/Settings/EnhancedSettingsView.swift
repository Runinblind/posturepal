// EnhancedSettingsView.swift
// PosturePal Pro - Week 4-5
// Enhanced settings with customization options

import SwiftUI

struct EnhancedSettingsView: View {
    @ObservedObject var settingsManager = SettingsManager.shared
    @ObservedObject var achievementManager = AchievementManager.shared
    
    @State private var showResetConfirmation = false
    @State private var showAnalytics = false
    @State private var showAchievements = false
    @State private var showPaywall = false
    
    var body: some View {
        NavigationView {
            Form {
                // User section
                userSection
                
                // Reminder settings
                reminderSection
                
                // Sound & Haptics
                soundHapticsSection
                
                // Appearance
                appearanceSection
                
                // Data & Privacy
                dataSection
                
                // Premium
                if !settingsManager.settings.isPremium {
                    premiumSection
                }
                
                // About
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Reset All Data?", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("This will permanently delete all check-ins, streaks, and achievements. This cannot be undone.")
            }
            .sheet(isPresented: $showAnalytics) {
                AnalyticsDashboardView(viewModel: AnalyticsViewModel())
            }
            .sheet(isPresented: $showAchievements) {
                AchievementsView()
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
    
    // MARK: - User Section
    
    private var userSection: some View {
        Section("Personalization") {
            HStack {
                Text("Name")
                TextField("Your name", text: $settingsManager.settings.userName)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    // MARK: - Reminder Section
    
    private var reminderSection: some View {
        Section("Reminders") {
            Picker("Interval", selection: $settingsManager.settings.reminderInterval) {
                ForEach(ReminderInterval.allCases) { interval in
                    HStack {
                        Text(interval.displayName)
                        if interval.isPremium && !settingsManager.settings.isPremium {
                            Image(systemName: "lock.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                    .tag(interval)
                }
            }
            .disabled(!settingsManager.settings.isPremium && settingsManager.settings.reminderInterval.isPremium)
            
            Picker("Notification Sound", selection: $settingsManager.settings.notificationSound) {
                ForEach(NotificationSound.allCases) { sound in
                    Text(sound.displayName).tag(sound)
                }
            }
            
            Toggle("Quiet Hours", isOn: $settingsManager.settings.quietHoursEnabled)
            
            if settingsManager.settings.quietHoursEnabled {
                DatePicker(
                    "Start",
                    selection: $settingsManager.settings.quietHoursStart,
                    displayedComponents: .hourAndMinute
                )
                
                DatePicker(
                    "End",
                    selection: $settingsManager.settings.quietHoursEnd,
                    displayedComponents: .hourAndMinute
                )
            }
        }
    }
    
    // MARK: - Sound & Haptics Section
    
    private var soundHapticsSection: some View {
        Section("Feedback") {
            Picker("Haptic Intensity", selection: $settingsManager.settings.hapticIntensity) {
                ForEach(HapticIntensity.allCases) { intensity in
                    Text(intensity.displayName).tag(intensity)
                }
            }
            
            if settingsManager.settings.hapticIntensity != .off {
                Button("Test Haptic") {
                    testHaptic()
                }
            }
        }
    }
    
    // MARK: - Appearance Section
    
    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: $settingsManager.settings.themeMode) {
                ForEach(ThemeMode.allCases) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
        }
    }
    
    // MARK: - Data Section
    
    private var dataSection: some View {
        Section("Data & Insights") {
            Button(action: { showAnalytics = true }) {
                HStack {
                    Label("Analytics Dashboard", systemImage: "chart.bar.fill")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Button(action: { showAchievements = true }) {
                HStack {
                    Label("Achievements", systemImage: "trophy.fill")
                    Spacer()
                    Badge(count: achievementManager.unlockedAchievements.count)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Button("Reset All Data", role: .destructive) {
                showResetConfirmation = true
            }
        }
    }
    
    // MARK: - Premium Section
    
    private var premiumSection: some View {
        Section {
            Button(action: { showPaywall = true }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Upgrade to Premium")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Custom intervals, Watch app & more")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "crown.fill")
                        .foregroundColor(.orange)
                }
            }
        }
    }
    
    // MARK: - About Section
    
    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
            
            Link("Privacy Policy", destination: URL(string: "https://posturepal.app/privacy")!)
            Link("Terms of Service", destination: URL(string: "https://posturepal.app/terms")!)
            Link("Support", destination: URL(string: "https://posturepal.app/support")!)
        }
    }
    
    // MARK: - Actions
    
    private func testHaptic() {
        let generator: UIImpactFeedbackGenerator
        
        switch settingsManager.settings.hapticIntensity {
        case .light:
            generator = UIImpactFeedbackGenerator(style: .light)
        case .medium:
            generator = UIImpactFeedbackGenerator(style: .medium)
        case .strong:
            generator = UIImpactFeedbackGenerator(style: .heavy)
        case .off:
            return
        }
        
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func resetAllData() {
        // Reset Core Data
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = CheckIn.fetchRequest()
        
        do {
            let checkIns = try context.fetch(fetchRequest)
            for checkIn in checkIns {
                context.delete(checkIn)
            }
            try context.save()
        } catch {
            print("Error resetting data: \(error)")
        }
        
        // Reset achievements
        achievementManager.resetAll()
        
        // Reset notifications
        NotificationService.shared.cancelAllNotifications()
        
        print("✅ All data reset")
    }
}

// MARK: - Badge Component

struct Badge: View {
    let count: Int
    
    var body: some View {
        Text("\(count)")
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.orange)
            .cornerRadius(10)
    }
}

// MARK: - Preview

struct EnhancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedSettingsView()
    }
}
