//
//  OnboardingContainerView.swift
//  PosturePal
//
//  Week 1 - Onboarding Flow Container
//

import SwiftUI

struct OnboardingContainerView: View {
    @State private var currentPage: Int = 0
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var notificationService: NotificationService
    
    private let totalPages = 3
    
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
                    }
                }
                .padding(.top, 20)
                
                // Onboarding pages
                TabView(selection: $currentPage) {
                    OnboardingPage1View()
                        .tag(0)
                    
                    OnboardingPage2View()
                        .tag(1)
                    
                    OnboardingPage3View(
                        onComplete: completeOnboarding
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
    
    private func completeOnboarding() {
        // Request notification permissions
        notificationService.requestAuthorization { granted in
            if granted {
                // Register notification actions
                notificationService.registerNotificationActions()
                
                // Schedule first reminder
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
            
            // Mark onboarding complete
            settingsManager.completeOnboarding()
        }
    }
}

// MARK: - Onboarding Page 1: Welcome

struct OnboardingPage1View: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Illustration placeholder
            Image(systemName: "figure.stand")
                .font(.system(size: 120))
                .foregroundColor(.white)
            
            Text("Stay Pain-Free")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
            
            Text("Gentle reminders to check your posture throughout the day")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

// MARK: - Onboarding Page 2: How It Works

struct OnboardingPage2View: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Illustration placeholder
            Image(systemName: "bell.badge")
                .font(.system(size: 120))
                .foregroundColor(.white)
            
            Text("Simple Reminders")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
            
            Text("We'll send you a gentle notification every hour. Just tap to check in.")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

// MARK: - Onboarding Page 3: Build Your Streak

struct OnboardingPage3View: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Illustration placeholder
            Text("🔥")
                .font(.system(size: 120))
            
            Text("Build Your Habit")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
            
            Text("Track your progress and build a daily streak. Your back will thank you! 🙏")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Get Started button
            Button(action: onComplete) {
                Text("Get Started")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "4A90E2"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Preview

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
            .environmentObject(SettingsManager.shared)
            .environmentObject(NotificationService.shared)
    }
}
