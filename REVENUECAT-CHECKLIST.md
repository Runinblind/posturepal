# RevenueCat Implementation Checklist

Quick reference for integrating RevenueCat into PosturePal Pro.

---

## 🎯 Step-by-Step Checklist

### Phase 1: Xcode Setup (5 minutes)

- [ ] Open Xcode project
- [ ] File → Add Package Dependencies
- [ ] Add: `https://github.com/RevenueCat/purchases-ios-spm.git`
- [ ] Select products: `RevenueCat` + `RevenueCatUI`
- [ ] Add to main app target

### Phase 2: Code Integration (15 minutes)

- [ ] Update `PosturePalApp.swift`:
  ```swift
  import RevenueCat
  
  init() {
      Purchases.configure(withAPIKey: "test_ronYRNgSkdhJsnoOhKqCzRjMcoH")
  }
  ```

- [ ] Create `SubscriptionManager.swift`
  - Copy complete implementation from `REVENUECAT-INTEGRATION.md` § 3

- [ ] Create `PaywallView.swift`
  - Copy complete implementation from `REVENUECAT-INTEGRATION.md` § 4

- [ ] Create `CustomerCenterView.swift` (optional)
  - Copy implementation from `REVENUECAT-INTEGRATION.md` § 5

- [ ] Add to `ContentView.swift` or main view:
  ```swift
  .environmentObject(SubscriptionManager.shared)
  ```

### Phase 3: RevenueCat Dashboard (10 minutes)

- [ ] Login to RevenueCat Dashboard: https://app.revenuecat.com
- [ ] Create project (if new)
- [ ] Add iOS app
- [ ] Copy API keys (test + production)

**Create Products:**
- [ ] Add product: `monthly` (Monthly subscription)
- [ ] Add product: `yearly` (Annual subscription)
- [ ] Add product: `lifetime` (One-time purchase)

**Create Entitlement:**
- [ ] Create entitlement: `posture app Pro`
- [ ] Attach all 3 products to this entitlement

**Create Offering:**
- [ ] Create offering: `default`
- [ ] Add package: Monthly → `monthly`
- [ ] Add package: Annual → `yearly`
- [ ] Add package: Lifetime → `lifetime`

### Phase 4: App Store Connect (10 minutes)

- [ ] Create In-App Purchases in App Store Connect
- [ ] Monthly subscription (auto-renewable)
  - Product ID: `monthly`
  - Price: $4.99/month
  - Free trial: 7 days
- [ ] Annual subscription (auto-renewable)
  - Product ID: `yearly`
  - Price: $29.99/year
  - Free trial: 7 days
- [ ] Lifetime (non-consumable)
  - Product ID: `lifetime`
  - Price: $49.99 (one-time)

### Phase 5: Testing (15 minutes)

- [ ] Create Sandbox Tester in App Store Connect
- [ ] Sign out of production Apple ID on device
- [ ] Run app in Xcode
- [ ] Test purchase flow (sandbox prompts for login)
- [ ] Verify purchase completes
- [ ] Verify `isProUser` becomes `true`
- [ ] Test restore purchases
- [ ] Test Customer Center

### Phase 6: Feature Protection (10 minutes)

- [ ] Add entitlement checks to premium features:
  ```swift
  if subscriptionManager.isProUser {
      // Show premium feature
  } else {
      // Show paywall or upgrade prompt
  }
  ```

- [ ] Locations to protect:
  - [ ] Unlimited reminders (vs 3/day free)
  - [ ] Apple Watch app access
  - [ ] Advanced analytics
  - [ ] Custom reminder sounds
  - [ ] Lifetime statistics

### Phase 7: Production Deploy (5 minutes)

Before App Store release:

- [ ] Replace test API key with **production key**:
  ```swift
  Purchases.configure(withAPIKey: "prod_XXXXXXXXXXXXXXXX")
  ```
- [ ] Set log level to `.info`:
  ```swift
  Purchases.logLevel = .info
  ```
- [ ] Verify all products are "Ready to Submit" in App Store Connect
- [ ] Test in TestFlight with real purchases
- [ ] Add privacy policy link to paywall
- [ ] Submit to App Review

---

## ⚡ Quick Test Commands

```swift
// Check subscription status
print("Pro user: \(SubscriptionManager.shared.isProUser)")

// Check entitlement
if let entitlement = SubscriptionManager.shared.customerInfo?.entitlements["posture app Pro"] {
    print("Active: \(entitlement.isActive)")
    print("Expires: \(entitlement.expirationDate)")
}

// List available packages
if let packages = SubscriptionManager.shared.currentOffering?.availablePackages {
    for pkg in packages {
        print("\(pkg.identifier): \(pkg.storeProduct.localizedPriceString)")
    }
}
```

---

## 🐛 Common Issues & Fixes

**Issue:** "No offerings found"
- ✅ Check RevenueCat Dashboard → Offerings → ensure `default` exists
- ✅ Verify products are attached to offering
- ✅ Wait 5 minutes for dashboard changes to propagate

**Issue:** "Product not available for purchase"
- ✅ Ensure App Store Connect In-App Purchases are approved
- ✅ Verify product IDs match exactly (case-sensitive)
- ✅ Check Bundle ID matches App Store Connect

**Issue:** Paywall shows but no prices
- ✅ Verify you're signed out of production Apple ID
- ✅ Ensure sandbox tester is configured
- ✅ Check internet connection (StoreKit requires network)

**Issue:** Purchase succeeds but `isProUser` stays `false`
- ✅ Verify entitlement name matches: `"posture app Pro"`
- ✅ Check products are attached to entitlement in dashboard
- ✅ Call `await checkSubscriptionStatus()` after purchase

---

## 📊 Validation Steps

Before considering integration complete:

- [ ] Can purchase monthly subscription
- [ ] Can purchase annual subscription
- [ ] Can purchase lifetime
- [ ] Restore purchases works
- [ ] Premium features unlock after purchase
- [ ] Customer Center shows subscription details
- [ ] Free trial applies (sandbox shows "You're currently in trial")
- [ ] Entitlement check works across app
- [ ] No crashes on purchase flow
- [ ] Error handling displays user-friendly messages

---

## 🚀 Ready to Launch?

Once all checkboxes are complete:
1. ✅ Full integration tested in sandbox
2. ✅ Production API key configured
3. ✅ TestFlight beta tested with real purchases
4. ✅ All features properly gated
5. ✅ Privacy policy linked from paywall

**You're ready to monetize! 💰**

---

For full implementation details, see: `REVENUECAT-INTEGRATION.md`
