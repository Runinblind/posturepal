//
//  PosturePalWatchApp.swift
//  PosturePal Watch App
//
//  Main entry point for the Apple Watch app
//  Standalone watchOS app with WatchConnectivity sync to iPhone
//

import SwiftUI
import WatchKit

@main
struct PosturePalWatchApp: App {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    @StateObject private var watchViewModel = WatchDashboardViewModel()
    
    var body: some Scene {
        WindowGroup {
            WatchDashboardView()
                .environmentObject(connectivityManager)
                .environmentObject(watchViewModel)
                .onAppear {
                    // Activate WatchConnectivity session
                    connectivityManager.activate()
                    
                    // Request initial data from iPhone
                    connectivityManager.requestStreakData()
                }
        }
    }
}
