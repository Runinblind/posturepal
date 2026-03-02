//
//  PaywallView.swift
//  PosturePal Pro
//
//  Subscription paywall screen
//  Presents monthly and annual subscription options with 7-day free trial
//

import SwiftUI
import RevenueCat

struct PaywallView: View {
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPlan: SubscriptionPlan = .annual
    @State private var isPurchasing: Bool = false
    @State private var showError: Bool = false
    
    enum SubscriptionPlan {
        case monthly
        case annual
    }
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [Color(hex: "4A90E2"), Color(hex: "66D9A6")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Close Button
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(8)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 8)
                    
                    // Header
                    VStack(spacing: 12) {
                        Text("✨")
                            .font(.system(size: 48))
                        
                        Text("Upgrade to Premium")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Unlock all features and build better habits")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 16)
                    
                    // Features List
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "⏱️", title: "Custom Intervals", description: "15-90 minute reminders")
                        FeatureRow(icon: "⌚️", title: "Apple Watch App", description: "Check in from your wrist")
                        FeatureRow(icon: "📊", title: "Unlimited Tracking", description: "Lifetime streak history")
                        FeatureRow(icon: "🌙", title: "Smart Scheduling", description: "Quiet hours automation")
                        FeatureRow(icon: "🎨", title: "Premium Themes", description: "Beautiful customization")
                        FeatureRow(icon: "🚀", title: "All Future Features", description: "Forever included")
                    }
                    .padding(.horizontal, 20)
                    
                    // Plan Selection
                    VStack(spacing: 12) {
                        PlanCard(
                            plan: .annual,
                            title: "Annual",
                            price: "$29.99/year",
                            savings: "Save 50%",
                            isSelected: selectedPlan == .annual
                        ) {
                            selectedPlan = .annual
                        }
                        
                        PlanCard(
                            plan: .monthly,
                            title: "Monthly",
                            price: "$4.99/month",
                            savings: nil,
                            isSelected: selectedPlan == .monthly
                        ) {
                            selectedPlan = .monthly
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Trial Info
                    Text("7-day free trial • Cancel anytime")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    // CTA Button
                    Button(action: {
                        purchaseSelectedPlan()
                    }) {
                        HStack {
                            if isPurchasing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            } else {
                                Text("Start Free Trial")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .foregroundColor(Color(hex: "4A90E2"))
                        .cornerRadius(12)
                    }
                    .disabled(isPurchasing)
                    .padding(.horizontal, 20)
                    
                    // Restore Button
                    Button(action: {
                        restorePurchases()
                    }) {
                        Text("Restore Purchases")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 8)
                    
                    // Legal
                    Text("By continuing, you agree to our Terms of Service and Privacy Policy. Subscription automatically renews unless cancelled 24 hours before renewal.")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 32)
                }
                .padding(.horizontal, 16)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            if let error = subscriptionManager.errorMessage {
                Text(error)
            }
        }
        .task {
            do {
                try await subscriptionManager.fetchOfferings()
            } catch {
                print("Error fetching offerings: \(error)")
            }
        }
    }
    
    // MARK: - Actions
    
    private func purchaseSelectedPlan() {
        isPurchasing = true
        
        Task {
            do {
                switch selectedPlan {
                case .monthly:
                    try await subscriptionManager.purchaseMonthly()
                case .annual:
                    try await subscriptionManager.purchaseAnnual()
                }
                
                // Success - dismiss paywall
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isPurchasing = false
                    showError = true
                }
            }
        }
    }
    
    private func restorePurchases() {
        isPurchasing = true
        
        Task {
            do {
                try await subscriptionManager.restorePurchases()
                
                await MainActor.run {
                    if subscriptionManager.isPremium {
                        dismiss()
                    } else {
                        isPurchasing = false
                        showError = true
                    }
                }
            } catch {
                await MainActor.run {
                    isPurchasing = false
                    showError = true
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 28))
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
    }
}

struct PlanCard: View {
    let plan: PaywallView.SubscriptionPlan
    let title: String
    let price: String
    let savings: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isSelected ? .white : Color(hex: "4A90E2"))
                    
                    Text(price)
                        .font(.system(size: 14))
                        .foregroundColor(isSelected ? .white.opacity(0.9) : Color(hex: "4A90E2").opacity(0.8))
                }
                
                Spacer()
                
                if let savings = savings {
                    Text(savings)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isSelected ? .white : Color(hex: "4A90E2"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isSelected ? Color.white.opacity(0.2) : Color(hex: "FFB84D").opacity(0.2))
                        .cornerRadius(12)
                }
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.4))
            }
            .padding(16)
            .background(isSelected ? Color.white.opacity(0.25) : Color.white.opacity(0.15))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
    }
}
