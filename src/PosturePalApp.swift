//
//  PosturePalApp.swift
//  PosturePal
//
//  Created by JARVIS App Dev System
//  Week 1-3 Foundation - Main App Entry Point
//
//  WEEK 2-3 UPDATES:
//  - Added WatchConnectivity integration
//  - Added RevenueCat subscription manager
//  - Configured shared app group for widgets
//

import SwiftUI
import UserNotifications

@main
struct PosturePalApp: App {
    // Core Data persistence controller
    @StateObject private var persistenceController = PersistenceController.shared
    
    // User settings manager
    @StateObject private var settingsManager = SettingsManager.shared
    
    // Notification service
    @StateObject private var notificationService = NotificationService.shared
    
    // WEEK 2-3: Apple Watch connectivity
    @StateObject private var phoneConnectivity = PhoneConnectivityManager.shared
    
    // WEEK 2-3: Subscription manager
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    
    init() {
        // Configure app on launch
        configureApp()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settingsManager)
                .environmentObject(notificationService)
                .environmentObject(phoneConnectivity)
                .environmentObject(subscriptionManager)
                .onAppear {
                    requestNotificationPermissions()
                    initializeWeek2Features()
                }
        }
    }
    
    // MARK: - Configuration
    
    private func configureApp() {
        // Any initial app configuration goes here
        print("📱 PosturePal launching...")
        
        // WEEK 2-3: Activate WatchConnectivity
        phoneConnectivity.activate()
    }
    
    private func requestNotificationPermissions() {
        notificationService.requestAuthorization { granted in
            if granted {
                print("✅ Notification permissions granted")
            } else {
                print("❌ Notification permissions denied")
            }
        }
    }
    
    // WEEK 2-3: Initialize new features
    private func initializeWeek2Features() {
        // Check subscription status
        subscriptionManager.checkSubscriptionStatus()
        
        // Send initial data to Watch if paired
        if phoneConnectivity.isPaired {
            phoneConnectivity.sendStreakUpdate()
        }
    }
}

// MARK: - Content View (Router)

struct ContentView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        if settingsManager.settings.onboardingCompleted {
            DashboardView()
        } else {
            OnboardingContainerView()
        }
    }
}
