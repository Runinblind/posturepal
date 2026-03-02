# RevenueCat Integration Guide - PosturePal Pro

Complete step-by-step guide for integrating RevenueCat SDK with Swift Package Manager.

---

## 📋 Prerequisites

- **API Key:** `test_ronYRNgSkdhJsnoOhKqCzRjMcoH`
- **Entitlement:** `posture app Pro`
- **Products:**
  - Monthly: `monthly`
  - Yearly: `yearly`
  - Lifetime: `lifetime`

---

## 1️⃣ Install RevenueCat SDK via Swift Package Manager

### In Xcode:

1. **Open your project** → Select your target
2. **File** → **Add Package Dependencies...**
3. **Enter URL:** `https://github.com/RevenueCat/purchases-ios-spm.git`
4. **Select Version:** Latest (5.x recommended)
5. **Add to Target:** Your main app target
6. Click **Add Package**

**Products to add:**
- `RevenueCat` (required)
- `RevenueCatUI` (for Paywall & Customer Center)

---

## 2️⃣ Configure RevenueCat in Your App

### Update `PosturePalApp.swift`

```swift
import SwiftUI
import RevenueCat

@main
struct PosturePalApp: App {
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    
    init() {
        // Configure RevenueCat on app launch
        Purchases.logLevel = .debug // Set to .info in production
        Purchases.configure(
            withAPIKey: "test_ronYRNgSkdhJsnoOhKqCzRjMcoH",
            appUserID: nil // nil = RevenueCat generates anonymous ID
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(subscriptionManager)
        }
    }
}
```

---

## 3️⃣ Create Subscription Manager

Create a new file: `SubscriptionManager.swift`

```swift
import Foundation
import RevenueCat
import Combine

@MainActor
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    // MARK: - Published Properties
    
    @Published var isProUser: Bool = false
    @Published var currentOffering: Offering?
    @Published var customerInfo: CustomerInfo?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Constants
    
    private let proEntitlementID = "posture app Pro"
    
    // MARK: - Initialization
    
    private init() {
        Task {
            await checkSubscriptionStatus()
            await fetchOfferings()
        }
        
        // Listen for customer info updates
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(customerInfoDidUpdate),
            name: .receivedUpdatedCustomerInfo,
            object: nil
        )
    }
    
    // MARK: - Public Methods
    
    /// Check if user has active Pro subscription
    func checkSubscriptionStatus() async {
        do {
            let info = try await Purchases.shared.customerInfo()
            await updateCustomerInfo(info)
        } catch {
            print("❌ Error fetching customer info: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    /// Fetch available offerings
    func fetchOfferings() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let offerings = try await Purchases.shared.offerings()
            currentOffering = offerings.current
            
            if let offering = offerings.current {
                print("✅ Fetched offering: \(offering.identifier)")
                print("📦 Available packages:")
                for package in offering.availablePackages {
                    print("  - \(package.identifier): \(package.storeProduct.localizedPriceString)")
                }
            } else {
                print("⚠️ No current offering found. Check RevenueCat Dashboard.")
            }
        } catch {
            print("❌ Error fetching offerings: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    /// Purchase a package
    func purchase(package: Package) async throws -> CustomerInfo {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Purchases.shared.purchase(package: package)
            await updateCustomerInfo(result.customerInfo)
            
            if result.userCancelled {
                print("ℹ️ User cancelled purchase")
            } else {
                print("✅ Purchase successful!")
            }
            
            return result.customerInfo
        } catch {
            print("❌ Purchase failed: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    /// Restore purchases
    func restorePurchases() async throws -> CustomerInfo {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let info = try await Purchases.shared.restorePurchases()
            await updateCustomerInfo(info)
            print("✅ Purchases restored")
            return info
        } catch {
            print("❌ Restore failed: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    /// Get package by identifier
    func package(for identifier: String) -> Package? {
        return currentOffering?.availablePackages.first { package in
            package.identifier == identifier
        }
    }
    
    // MARK: - Private Methods
    
    private func updateCustomerInfo(_ info: CustomerInfo) {
        customerInfo = info
        isProUser = info.entitlements[proEntitlementID]?.isActive == true
        
        print("👤 Customer Info Updated:")
        print("  - Pro User: \(isProUser)")
        print("  - Active Subscriptions: \(info.activeSubscriptions)")
        print("  - Entitlements: \(info.entitlements.all.keys)")
    }
    
    @objc private func customerInfoDidUpdate(notification: Notification) {
        guard let info = notification.userInfo?["customerInfo"] as? CustomerInfo else {
            return
        }
        Task { @MainActor in
            updateCustomerInfo(info)
        }
    }
}
```

---

## 4️⃣ Create Paywall View

Create a new file: `PaywallView.swift`

```swift
import SwiftUI
import RevenueCat
import RevenueCatUI

struct PaywallView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) var dismiss
    @State private var isProcessing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.yellow)
                        
                        Text("PosturePal Pro")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Unlock all premium features")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 40)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "bell.fill", title: "Unlimited Reminders", description: "Set as many custom reminders as you need")
                        FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Lifetime Statistics", description: "Track your posture journey forever")
                        FeatureRow(icon: "applewatch", title: "Apple Watch App", description: "Check in from your wrist")
                        FeatureRow(icon: "speaker.wave.3.fill", title: "Custom Sounds", description: "Personalize your reminder alerts")
                        FeatureRow(icon: "chart.bar.fill", title: "Advanced Analytics", description: "Deep insights into your habits")
                    }
                    .padding(.horizontal, 24)
                    
                    // Subscription packages
                    if let offering = subscriptionManager.currentOffering {
                        VStack(spacing: 12) {
                            ForEach(offering.availablePackages, id: \.identifier) { package in
                                PackageButton(package: package) {
                                    await purchasePackage(package)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    } else {
                        ProgressView()
                            .tint(.white)
                    }
                    
                    // Restore button
                    Button("Restore Purchases") {
                        Task {
                            await restorePurchases()
                        }
                    }
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 8)
                    
                    // Legal text
                    Text("Auto-renewable. Cancel anytime in Settings.")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                }
            }
            
            // Loading overlay
            if isProcessing {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.8))
                    .padding()
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Actions
    
    private func purchasePackage(_ package: Package) async {
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            let customerInfo = try await subscriptionManager.purchase(package: package)
            
            if customerInfo.entitlements["posture app Pro"]?.isActive == true {
                // Purchase successful, dismiss paywall
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func restorePurchases() async {
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            let customerInfo = try await subscriptionManager.restorePurchases()
            
            if customerInfo.entitlements["posture app Pro"]?.isActive == true {
                dismiss()
            } else {
                errorMessage = "No active subscriptions found."
                showError = true
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - Supporting Views

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
    }
}

struct PackageButton: View {
    let package: Package
    let action: () async -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(package.storeProduct.localizedTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if let intro = package.storeProduct.introductoryDiscount {
                        Text("7-day free trial")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(package.storeProduct.localizedPriceString)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if package.packageType == .annual {
                        Text("Best Value")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(isPressed ? 0.3 : 0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PaywallView()
        .environmentObject(SubscriptionManager.shared)
}
```

---

## 5️⃣ Add Customer Center (Optional but Recommended)

The Customer Center provides a self-service UI for users to manage subscriptions.

### Add to Settings or Profile View

```swift
import SwiftUI
import RevenueCatUI

struct SettingsView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showCustomerCenter = false
    
    var body: some View {
        List {
            Section("Subscription") {
                if subscriptionManager.isProUser {
                    HStack {
                        Text("Status")
                        Spacer()
                        Text("Pro Member")
                            .foregroundStyle(.green)
                            .fontWeight(.semibold)
                    }
                    
                    Button("Manage Subscription") {
                        showCustomerCenter = true
                    }
                } else {
                    Button("Upgrade to Pro") {
                        // Show paywall
                    }
                }
            }
        }
        .sheet(isPresented: $showCustomerCenter) {
            // RevenueCat's built-in Customer Center
            CustomerCenterView()
        }
    }
}
```

### Customer Center View

```swift
import SwiftUI
import RevenueCatUI

struct CustomerCenterView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let customerCenterVC = CustomerCenterViewController()
        let navController = UINavigationController(rootViewController: customerCenterVC)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed
    }
}
```

---

## 6️⃣ Implement Entitlement Checking

### Protect Premium Features

```swift
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var showPaywall = false
    
    var body: some View {
        VStack {
            // Free features
            Text("Basic Dashboard")
            
            // Premium feature - protected
            if subscriptionManager.isProUser {
                AdvancedAnalyticsView()
            } else {
                Button("Unlock Advanced Analytics") {
                    showPaywall = true
                }
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
                .environmentObject(subscriptionManager)
        }
    }
}
```

### Check Specific Entitlements

```swift
// In any view or view model
if let entitlement = subscriptionManager.customerInfo?.entitlements["posture app Pro"],
   entitlement.isActive {
    // User has active Pro subscription
    print("✅ Pro user - enable premium features")
} else {
    // Free user
    print("ℹ️ Free user - show paywall")
}
```

---

## 7️⃣ Handle Product Configuration

### In RevenueCat Dashboard:

1. **Create Products:**
   - Go to Products → Add Product
   - Monthly: `monthly` (App Store Product ID)
   - Yearly: `yearly` (App Store Product ID)
   - Lifetime: `lifetime` (App Store Product ID)

2. **Create Entitlement:**
   - Go to Entitlements → Add Entitlement
   - Name: `posture app Pro`
   - Attach all 3 products to this entitlement

3. **Create Offering:**
   - Go to Offerings → Add Offering
   - Identifier: `default`
   - Add packages:
     - Monthly package → `monthly` product
     - Annual package → `yearly` product
     - Lifetime package → `lifetime` product

### Access Packages in Code

```swift
// Get specific package
if let monthlyPackage = subscriptionManager.package(for: "$rc_monthly") {
    // Use monthly package
}

if let annualPackage = subscriptionManager.package(for: "$rc_annual") {
    // Use annual package
}

if let lifetimePackage = subscriptionManager.package(for: "$rc_lifetime") {
    // Use lifetime package
}

// Or iterate all packages
if let packages = subscriptionManager.currentOffering?.availablePackages {
    for package in packages {
        print("\(package.identifier): \(package.storeProduct.localizedPriceString)")
    }
}
```

---

## 8️⃣ Error Handling Best Practices

```swift
import RevenueCat

extension SubscriptionManager {
    func handlePurchaseError(_ error: Error) -> String {
        if let rcError = error as? ErrorCode {
            switch rcError {
            case .networkError:
                return "No internet connection. Please try again."
            case .purchaseCancelledError:
                return "Purchase cancelled."
            case .productNotAvailableForPurchaseError:
                return "This product is not available."
            case .purchaseNotAllowedError:
                return "Purchases are not allowed on this device."
            case .purchaseInvalidError:
                return "Invalid purchase. Please contact support."
            default:
                return "Purchase failed: \(error.localizedDescription)"
            }
        }
        return error.localizedDescription
    }
}
```

---

## 9️⃣ Testing Guide

### Test with Sandbox Users

1. **Create Sandbox Tester:**
   - App Store Connect → Users and Access → Sandbox Testers
   - Create test Apple ID

2. **Sign Out of Production iTunes:**
   - Settings → Your Name → Media & Purchases → Sign Out
   - **Don't sign in with sandbox account yet**

3. **Test Purchase Flow:**
   - Run app → Trigger purchase
   - App will prompt for Apple ID
   - Sign in with sandbox tester account
   - Complete purchase (no actual charge)

4. **Test Scenarios:**
   - ✅ Monthly subscription
   - ✅ Annual subscription
   - ✅ Lifetime purchase
   - ✅ Restore purchases
   - ✅ Subscription expiration
   - ✅ Subscription cancellation

---

## 🔟 Production Checklist

Before releasing to App Store:

- [ ] Replace test API key with **production API key** from RevenueCat
- [ ] Set `Purchases.logLevel = .info` (not `.debug`)
- [ ] Test all purchase flows with sandbox accounts
- [ ] Verify entitlement checking works correctly
- [ ] Test restore purchases functionality
- [ ] Verify Customer Center works
- [ ] Add privacy policy and terms of service links
- [ ] Test on multiple iOS versions
- [ ] Test with real App Store products (in TestFlight)

---

## 📚 Additional Resources

- **RevenueCat Docs:** https://www.revenuecat.com/docs
- **SwiftUI Guide:** https://www.revenuecat.com/docs/getting-started/displaying-products#swiftui
- **Paywalls:** https://www.revenuecat.com/docs/tools/paywalls
- **Customer Center:** https://www.revenuecat.com/docs/tools/customer-center
- **Testing Guide:** https://www.revenuecat.com/docs/test-and-launch/sandbox

---

## 🎯 Quick Integration Summary

1. ✅ Add Swift Package: `https://github.com/RevenueCat/purchases-ios-spm.git`
2. ✅ Configure in `PosturePalApp.swift` with API key
3. ✅ Create `SubscriptionManager.swift` (singleton)
4. ✅ Create `PaywallView.swift` (with custom UI)
5. ✅ Add `CustomerCenterView.swift` (for subscription management)
6. ✅ Protect features with entitlement checks
7. ✅ Configure products in RevenueCat Dashboard
8. ✅ Test with sandbox accounts
9. ✅ Deploy with production API key

**You're ready to monetize! 🚀**
