// EnhancedOnboardingView.swift
// PosturePal Pro - Week 4-5
// Enhanced onboarding with permissions and personalization

import SwiftUI

struct EnhancedOnboardingView: View {
    @State private var currentPage: Int = 0
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var notificationService: NotificationService
    
    private let totalPages = 5
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "4A90E2"), Color(hex: "66D9A6")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                            .frame(width: 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.top, 20)
                
                // Onboarding pages
                TabView(selection: $currentPage) {
                    WelcomePage(nextAction: nextPage)
                        .tag(0)
                    
                    PersonalizationPage(nextAction: nextPage)
                        .tag(1)
                    
                    GoalsPage(nextAction: nextPage)
                        .tag(2)
                    
                    NotificationPermissionPage(nextAction: nextPage)
                        .tag(3)
                    
                    HealthKitPermissionPage(completeAction: completeOnboarding)
                        .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
    
    private func nextPage() {
        withAnimation {
            currentPage += 1
        }
    }
    
    private func completeOnboarding() {
        settingsManager.completeOnboarding()
    }
}

// MARK: - Welcome Page

struct WelcomePage: View {
    let nextAction: () -> Void
    
    var body: some View {
        OnboardingPageTemplate(
            icon: "figure.stand",
            title: "Welcome to PosturePal",
            description: "Build better posture habits with gentle reminders and streak tracking",
            primaryButtonTitle: "Get Started",
            primaryButtonAction: nextAction
        )
    }
}

// MARK: - Personalization Page

struct PersonalizationPage: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var name: String = ""
    let nextAction: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                Text("What's your name?")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("We'll use it to personalize your experience")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            TextField("Your name", text: $name)
                .textFieldStyle(.roundedBorder)
                .textContentType(.name)
                .autocapitalization(.words)
                .padding(.horizontal, 40)
                .onAppear {
                    name = settingsManager.settings.userName
                }
            
            Spacer()
            
            Button(action: {
                settingsManager.settings.userName = name.isEmpty ? "there" : name
                nextAction()
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(Color(hex: "4A90E2"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Goals Page

struct GoalsPage: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedInterval: ReminderInterval = .sixtyMinutes
    let nextAction: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "target")
                .font(.system(size: 80))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                Text("Set Your Reminder")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("How often would you like to be reminded to check your posture?")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Picker("Interval", selection: $selectedInterval) {
                ForEach(ReminderInterval.allCases.filter { $0 == .sixtyMinutes }) { interval in
                    Text(interval.displayName).tag(interval)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)
            
            Text("You can customize this later in Settings")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Button(action: {
                settingsManager.settings.reminderInterval = selectedInterval
                nextAction()
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(Color(hex: "4A90E2"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Notification Permission Page

struct NotificationPermissionPage: View {
    @EnvironmentObject var notificationService: NotificationService
    @State private var permissionGranted = false
    let nextAction: () -> Void
    
    var body: some View {
        OnboardingPageTemplate(
            icon: "bell.badge.fill",
            title: "Enable Notifications",
            description: "Get gentle reminders throughout your day to check your posture. You can customize quiet hours in Settings.",
            primaryButtonTitle: permissionGranted ? "Continue" : "Allow Notifications",
            primaryButtonAction: {
                if permissionGranted {
                    nextAction()
                } else {
                    requestNotificationPermission()
                }
            },
            secondaryButtonTitle: permissionGranted ? nil : "Skip for now",
            secondaryButtonAction: permissionGranted ? nil : nextAction
        )
    }
    
    private func requestNotificationPermission() {
        notificationService.requestAuthorization { granted in
            permissionGranted = granted
            if granted {
                notificationService.registerNotificationActions()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    nextAction()
                }
            }
        }
    }
}

// MARK: - HealthKit Permission Page

struct HealthKitPermissionPage: View {
    @State private var skipped = false
    let completeAction: () -> Void
    
    var body: some View {
        OnboardingPageTemplate(
            icon: "heart.text.square.fill",
            title: "Connect HealthKit (Optional)",
            description: "PosturePal can log your check-ins to Apple Health for a complete wellness picture.",
            primaryButtonTitle: "Connect HealthKit",
            primaryButtonAction: {
                requestHealthKitPermission()
            },
            secondaryButtonTitle: "Skip for now",
            secondaryButtonAction: {
                completeAction()
            }
        )
    }
    
    private func requestHealthKitPermission() {
        // In a real implementation, use HealthKit framework
        // For now, just complete onboarding
        completeAction()
    }
}

// MARK: - Onboarding Page Template

struct OnboardingPageTemplate: View {
    let icon: String
    let title: String
    let description: String
    let primaryButtonTitle: String
    let primaryButtonAction: () -> Void
    var secondaryButtonTitle: String? = nil
    var secondaryButtonAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: primaryButtonAction) {
                    Text(primaryButtonTitle)
                        .font(.headline)
                        .foregroundColor(Color(hex: "4A90E2"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                
                if let secondaryTitle = secondaryButtonTitle,
                   let secondaryAction = secondaryButtonAction {
                    Button(action: secondaryAction) {
                        Text(secondaryTitle)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Preview

struct EnhancedOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedOnboardingView()
            .environmentObject(SettingsManager.shared)
            .environmentObject(NotificationService.shared)
    }
}
