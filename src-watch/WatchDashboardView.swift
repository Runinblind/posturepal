//
//  WatchDashboardView.swift
//  PosturePal Watch App
//
//  Main dashboard view for Apple Watch
//  Shows streak, today's check-ins, and quick check-in button
//

import SwiftUI

struct WatchDashboardView: View {
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    @EnvironmentObject var viewModel: WatchDashboardViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Streak Section
                VStack(spacing: 4) {
                    Text("🔥")
                        .font(.system(size: 32))
                    
                    Text("\(connectivityManager.currentStreak)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                    
                    Text(connectivityManager.currentStreak == 1 ? "day streak" : "days")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
                
                // Today's Check-ins
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        ForEach(0..<5, id: \.self) { index in
                            Circle()
                                .fill(index < connectivityManager.todayCheckIns ? Color.green : Color.gray.opacity(0.3))
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                    Text("Today: \(connectivityManager.todayCheckIns)/5")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
                
                // Check-in Button
                Button(action: {
                    viewModel.checkIn()
                }) {
                    HStack {
                        Image(systemName: "hand.raised.fill")
                        Text("Check In")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(viewModel.isCheckingIn)
                
                // Next Reminder
                if let nextReminder = connectivityManager.nextReminderTime {
                    VStack(spacing: 2) {
                        Text("Next reminder")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(viewModel.nextReminderText(from: nextReminder))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.top, 4)
                }
                
                // Connection Status
                if !connectivityManager.isReachable {
                    HStack(spacing: 4) {
                        Image(systemName: "iphone.slash")
                            .font(.caption2)
                        Text("Offline mode")
                            .font(.caption2)
                    }
                    .foregroundColor(.orange)
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal, 8)
        }
        .overlay(
            // Success Animation
            Group {
                if viewModel.showSuccessAnimation {
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("Nice work!")
                            .font(.headline)
                        
                        if connectivityManager.currentStreak > 0 {
                            Text("Streak: \(connectivityManager.currentStreak)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.9))
                    .transition(.opacity)
                }
            }
        )
        .navigationTitle("PosturePal")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WatchDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let connectivity = WatchConnectivityManager.shared
        connectivity.currentStreak = 42
        connectivity.todayCheckIns = 3
        
        return WatchDashboardView()
            .environmentObject(connectivity)
            .environmentObject(WatchDashboardViewModel())
    }
}
