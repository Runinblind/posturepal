//
//  SubscriptionManager.swift
//  PosturePal Pro
//
//  RevenueCat subscription management
//  Handles premium entitlement checks, purchases, and restoration
//

import Foundation
import RevenueCat
import Combine

/// Manages subscription state and RevenueCat integration
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    // MARK: - Published Properties
    
    @Published var isPremium: Bool = false
    @Published var currentOffering: Offering?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Product IDs
    
    enum ProductID {
        static let monthly = "com.posturepal.premium.monthly"
        static let annual = "com.posturepal.premium.annual"
    }
    
    // MARK: - Initialization
    
    private init() {
        setupRevenueCat()
        checkSubscriptionStatus()
    }
    
    // MARK: - Setup
    
    /// Configure RevenueCat SDK
    private func setupRevenueCat() {
        // TODO: Replace with your actual RevenueCat API key
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_XXXXXXXXXXXXX")
        
        print("💰 RevenueCat configured")
    }
    
    // MARK: - Subscription Status
    
    /// Check current subscription status
    func checkSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { [weak self] customerInfo, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("💰 Error fetching customer info: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                let isPro = customerInfo?.entitlements["premium"]?.isActive == true
                self?.isPremium = isPro
                
                // Sync with UserSettings
                SettingsManager.shared.settings.isPremium = isPro
                
                print("💰 Premium status: \(isPro)")
            }
        }
    }
    
    // MARK: - Offerings
    
    /// Fetch available subscription offerings
    func fetchOfferings() async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let offerings = try await Purchases.shared.offerings()
            
            DispatchQueue.main.async { [weak self] in
                self?.currentOffering = offerings.current
                self?.isLoading = false
                print("💰 Fetched offerings: \(offerings.current?.availablePackages.count ?? 0) packages")
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
            }
            throw error
        }
    }
    
    // MARK: - Purchase
    
    /// Purchase a subscription package
    /// - Parameter package: The package to purchase
    func purchase(package: Package) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Purchases.shared.purchase(package: package)
            
            DispatchQueue.main.async { [weak self] in
                let isPro = result.customerInfo.entitlements["premium"]?.isActive == true
                self?.isPremium = isPro
                SettingsManager.shared.settings.isPremium = isPro
                self?.isLoading = false
                
                print("💰 Purchase successful - Premium: \(isPro)")
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
            }
            throw error
        }
    }
    
    /// Purchase monthly subscription
    func purchaseMonthly() async throws {
        guard let offering = currentOffering,
              let monthlyPackage = offering.monthly else {
            throw SubscriptionError.noMonthlyPackage
        }
        
        try await purchase(package: monthlyPackage)
    }
    
    /// Purchase annual subscription
    func purchaseAnnual() async throws {
        guard let offering = currentOffering,
              let annualPackage = offering.annual else {
            throw SubscriptionError.noAnnualPackage
        }
        
        try await purchase(package: annualPackage)
    }
    
    // MARK: - Restore
    
    /// Restore previous purchases
    func restorePurchases() async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            
            DispatchQueue.main.async { [weak self] in
                let isPro = customerInfo.entitlements["premium"]?.isActive == true
                self?.isPremium = isPro
                SettingsManager.shared.settings.isPremium = isPro
                self?.isLoading = false
                
                print("💰 Restore successful - Premium: \(isPro)")
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
            }
            throw error
        }
    }
    
    // MARK: - Helper Methods
    
    /// Get price string for a package
    func priceString(for package: Package) -> String {
        package.storeProduct.localizedPriceString
    }
    
    /// Get introductory offer text if available
    func introOfferText(for package: Package) -> String? {
        guard let intro = package.storeProduct.introductoryDiscount else {
            return nil
        }
        
        return "7-day free trial, then \(package.storeProduct.localizedPriceString)"
    }
}

// MARK: - Errors

enum SubscriptionError: LocalizedError {
    case noMonthlyPackage
    case noAnnualPackage
    
    var errorDescription: String? {
        switch self {
        case .noMonthlyPackage:
            return "Monthly subscription not available"
        case .noAnnualPackage:
            return "Annual subscription not available"
        }
    }
}
