//
//  SettingsView.swift
//  PosturePal
//
//  Week 1 - Settings Screen
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                // Reminders Section
                Section("Reminders") {
                    Button(action: { viewModel.showIntervalPicker = true }) {
                        HStack {
                            Text("Interval")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(viewModel.selectedInterval.displayName)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Toggle("Quiet Hours", isOn: $viewModel.quietHoursEnabled)
                        .onChange(of: viewModel.quietHoursEnabled) { newValue in
                            viewModel.toggleQuietHours(newValue)
                        }
                    
                    if viewModel.quietHoursEnabled {
                        DatePicker(
                            "From",
                            selection: $viewModel.quietHoursStart,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: viewModel.quietHoursStart) { newValue in
                            viewModel.updateQuietHoursStart(newValue)
                        }
                        
                        DatePicker(
                            "To",
                            selection: $viewModel.quietHoursEnd,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: viewModel.quietHoursEnd) { newValue in
                            viewModel.updateQuietHoursEnd(newValue)
                        }
                    }
                }
                
                // Apple Watch Section
                Section("Apple Watch") {
                    Toggle("Watch Notifications", isOn: $viewModel.watchNotificationsEnabled)
                        .onChange(of: viewModel.watchNotificationsEnabled) { newValue in
                            viewModel.toggleWatchNotifications(newValue)
                        }
                }
                
                // Account Section
                Section("Account") {
                    if !viewModel.isPremium {
                        Button(action: { viewModel.showUpgradeScreen() }) {
                            HStack {
                                Text("🌟 Upgrade to Pro")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        HStack {
                            Text("Status")
                            Spacer()
                            Text("Premium ✨")
                                .foregroundColor(Color(hex: "FFB84D"))
                        }
                    }
                }
                
                // Data Section
                Section("Data") {
                    Button(action: { viewModel.requestResetStreak() }) {
                        Text("Reset Streak")
                            .foregroundColor(.red)
                    }
                }
                
                // About Section
                Section {
                    VStack(spacing: 8) {
                        Text("Version 1.0.0")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        Text("Made with ❤️ for your back")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showIntervalPicker) {
                IntervalPickerView(
                    selectedInterval: $viewModel.selectedInterval,
                    isPremium: viewModel.isPremium,
                    onSelect: { interval in
                        viewModel.updateInterval(interval)
                        viewModel.showIntervalPicker = false
                    }
                )
            }
            .alert("Reset Streak?", isPresented: $viewModel.showResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    viewModel.confirmResetStreak(context: context)
                }
            } message: {
                Text("This will delete all your check-ins and reset your streak to zero. This action cannot be undone.")
            }
            .sheet(isPresented: $viewModel.showPaywall) {
                PaywallView()
            }
        }
    }
}

// MARK: - Interval Picker

struct IntervalPickerView: View {
    @Binding var selectedInterval: ReminderInterval
    let isPremium: Bool
    let onSelect: (ReminderInterval) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(ReminderInterval.allCases) { interval in
                    Button(action: {
                        onSelect(interval)
                    }) {
                        HStack {
                            Text(interval.displayName)
                                .foregroundColor(interval.isPremium && !isPremium ? .secondary : .primary)
                            
                            Spacer()
                            
                            if interval.isPremium && !isPremium {
                                Text("Pro")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(hex: "FFB84D"))
                                    .cornerRadius(4)
                            }
                            
                            if interval == selectedInterval {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(hex: "4A90E2"))
                            }
                        }
                    }
                    .disabled(interval.isPremium && !isPremium)
                }
            }
            .navigationTitle("Reminder Interval")
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
}

// MARK: - Paywall View (Placeholder)

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                Text("🌟")
                    .font(.system(size: 80))
                
                Text("Upgrade to Premium")
                    .font(.system(size: 28, weight: .bold))
                
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "clock", text: "Custom intervals (15-90 min)")
                    FeatureRow(icon: "applewatch", text: "Apple Watch app")
                    FeatureRow(icon: "moon.fill", text: "Smart scheduling")
                    FeatureRow(icon: "chart.bar.fill", text: "Unlimited streak tracking")
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {}) {
                        VStack(spacing: 4) {
                            Text("$29.99/year")
                                .font(.system(size: 20, weight: .bold))
                            Text("Save 50%")
                                .font(.system(size: 13))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(hex: "4A90E2"))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {}) {
                        Text("$4.99/month")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(hex: "4A90E2").opacity(0.7))
                            .cornerRadius(12)
                    }
                    
                    Button("Restore Purchases") {
                        // Restore logic
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "66D9A6"))
                .frame(width: 30)
            Text(text)
                .font(.system(size: 17))
        }
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
