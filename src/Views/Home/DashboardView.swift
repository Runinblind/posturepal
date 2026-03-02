//
//  DashboardView.swift
//  PosturePal
//
//  Week 1 - Main Dashboard Screen
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: DashboardViewModel
    @State private var showSettings = false
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: DashboardViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Card
                    StreakCardView(streakData: viewModel.streakData)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    // Today's Status
                    TodayStatusView(
                        checkIns: viewModel.todayCheckIns,
                        progress: viewModel.todayProgress
                    )
                    .padding(.horizontal, 20)
                    
                    // Check-in button
                    Button(action: {
                        viewModel.performCheckIn()
                    }) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                            Text("Check My Posture Now")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "4A90E2"))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    // Quick Stats
                    QuickStatsView(streakData: viewModel.streakData)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("PosturePal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .overlay(
                celebrationOverlay
            )
            .refreshable {
                viewModel.refresh()
            }
        }
    }
    
    @ViewBuilder
    private var celebrationOverlay: some View {
        if viewModel.showCelebration, let milestone = viewModel.celebrationMilestone {
            CelebrationView(milestone: milestone) {
                viewModel.dismissCelebration()
            }
        }
    }
}

// MARK: - Streak Card

struct StreakCardView: View {
    let streakData: StreakData
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color(hex: "4A90E2"), Color(hex: "66D9A6")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(20)
            
            VStack(spacing: 12) {
                Text("🔥")
                    .font(.system(size: 48))
                
                Text("\(streakData.currentStreak)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("day streak")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
                
                if let lastCheckIn = streakData.lastCheckInDate {
                    Text("Last: \(formattedDate(lastCheckIn))")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(32)
        }
        .frame(height: 250)
        .shadow(color: Color(hex: "4A90E2").opacity(0.15), radius: 16, x: 0, y: 4)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return "Today \(formatter.string(from: date))"
    }
}

// MARK: - Today's Status

struct TodayStatusView: View {
    let checkIns: [CheckIn]
    let progress: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Status")
                .font(.system(size: 22, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(checkIns) { checkIn in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "66D9A6"))
                        Text(formatTime(checkIn.timestamp))
                            .font(.system(size: 15))
                    }
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(Color(hex: "4A90E2"))
                    Text("Next reminder soon")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Quick Stats

struct QuickStatsView: View {
    let streakData: StreakData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Stats")
                .font(.system(size: 22, weight: .semibold))
            
            VStack(spacing: 8) {
                HStack {
                    Text("Total Check-Ins:")
                    Spacer()
                    Text("\(streakData.totalCheckIns)")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Longest Streak:")
                    Spacer()
                    Text("\(streakData.longestStreak) days")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Monthly Consistency:")
                    Spacer()
                    Text("\(Int(streakData.monthlyConsistency * 100))%")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "66D9A6"))
                }
            }
            .font(.system(size: 15))
        }
    }
}

// MARK: - Celebration View

struct CelebrationView: View {
    let milestone: Int
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)
            
            VStack(spacing: 20) {
                Text("🎉")
                    .font(.system(size: 80))
                
                Text("Amazing!")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                
                Text("\(milestone) Day Streak!")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
                
                Button("Continue", action: onDismiss)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "4A90E2"))
                    .frame(width: 200, height: 50)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(40)
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
