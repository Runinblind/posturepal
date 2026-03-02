# PosturePal Pro - Troubleshooting Common Issues

**Quick reference for the top 20 integration problems and their fixes.**

Format: **Problem** → **Solution**

---

## 🔨 Build Errors

### 1. "No such module 'RevenueCat'"

**Symptom:** Build fails with import error  
**When:** Phase 1 or early Phase 3

**Solution:**
1. Ensure you completed Phase 2 (SPM installation)
2. File → Add Package Dependencies
3. Add `https://github.com/RevenueCat/purchases-ios`
4. Clean build folder (Cmd+Shift+K)
5. Build again

---

### 2. "Cannot find type 'View' in scope"

**Symptom:** SwiftUI views won't compile  
**When:** After importing files

**Solution:**
Add to top of file:
```swift
import SwiftUI
```

---

### 3. "Cannot find 'HKQuantityType' in scope"

**Symptom:** HealthKit types undefined  
**When:** Health-related files fail to build

**Solution:**
1. Add to top of file:
```swift
import HealthKit
```
2. Verify HealthKit capability added in target
3. Check Info.plist has NSHealthShareUsageDescription

---

### 4. "Use of undeclared type 'WidgetKit'"

**Symptom:** Widget files won't compile  
**When:** Building widget extension

**Solution:**
1. Add to widget files:
```swift
import WidgetKit
import SwiftUI
```
2. Check file target membership (must be in Widget Extension)
3. File Inspector → Target Membership → ✅ PosturePalWidgets

---

### 5. "Cannot find 'AppIcon' in asset catalog"

**Symptom:** Missing app icon error  
**When:** First build

**Solution:**
1. Open Assets.xcassets
2. Right-click → App Icons & Launch Images → New iOS App Icon
3. Add at least 1024×1024 icon (can use placeholder)
4. Or delete reference to AppIcon in project settings temporarily

---

### 6. "Duplicate symbol '_OBJC_CLASS_$_AppDelegate'"

**Symptom:** Multiple app delegates  
**When:** After importing files

**Solution:**
1. PosturePal uses SwiftUI lifecycle (no AppDelegate needed)
2. Check for AppDelegate.swift in project
3. If exists and unused, delete it
4. Ensure @main is only on PosturePal_ProApp.swift

---

### 7. "Provisioning profile doesn't match bundle identifier"

**Symptom:** Signing error  
**When:** Running on device

**Solution:**
1. Go to Signing & Capabilities
2. Check Bundle Identifier: `com.yourcompany.posturepal`
3. Ensure it matches App Store Connect
4. Select correct Team
5. Toggle "Automatically manage signing" off then on
6. Or manually download profile from developer portal

---

### 8. "Module compiled with Swift 6.0 cannot be imported by Swift 5.x"

**Symptom:** Swift version mismatch  
**When:** After adding dependencies

**Solution:**
1. Project Settings → Build Settings
2. Search "Swift Language Version"
3. Set to Swift 5 (all targets)
4. Or update Xcode to latest version
5. Clean build folder and rebuild

---

### 9. "iOS Deployment Target 'iOS 15.0' is less than 'iOS 16.0'"

**Symptom:** Deployment target mismatch  
**When:** Building with dependencies

**Solution:**
1. Select Project (blue icon) → Project (not target)
2. Build Settings → iOS Deployment Target → iOS 16.0
3. Select each Target → Build Settings → iOS Deployment Target → iOS 16.0
4. Ensure ALL targets match (iOS, Watch, Widget)
5. Clean and rebuild

---

### 10. "Type 'SomeView' does not conform to protocol 'View'"

**Symptom:** SwiftUI view protocol error  
**When:** Custom views fail to build

**Solution:**
Check the view has:
```swift
struct SomeView: View {
    var body: some View {  // ← MUST have this
        // UI here
    }
}
```
If using @ViewBuilder, ensure it returns a valid View.

---

## 💥 Runtime Crashes

### 11. App crashes on launch (no error message)

**Symptom:** App builds but crashes immediately  
**When:** First run

**Solution:**
1. Check Xcode console for crash log
2. Common causes:
   - Missing Info.plist keys (NSHealthShareUsageDescription, etc.)
   - Force-unwrapping nil optional (`!`)
   - Missing asset or resource
3. Run in Debug mode, set exception breakpoint
4. Look for red error in console: "Terminating app due to..."

---

### 12. "This app has crashed because it attempted to access privacy-sensitive data"

**Symptom:** Crash with privacy error  
**When:** First access to HealthKit

**Solution:**
Add to Info.plist (iOS App):
```xml
<key>NSHealthShareUsageDescription</key>
<string>PosturePal needs access to your posture and movement data.</string>

<key>NSHealthUpdateUsageDescription</key>
<string>PosturePal records your posture sessions to track progress.</string>
```

---

### 13. Widget not appearing on home screen

**Symptom:** Can't find widget in widget gallery  
**When:** After install

**Solution:**
1. Widget must be in separate extension target
2. Check target membership of widget files
3. Ensure widget has `@main` struct conforming to WidgetBundle
4. Re-run on device (not just simulator)
5. Long-press home screen → + → Search "PosturePal"
6. May need to restart device

---

### 14. Watch app shows loading spinner forever

**Symptom:** Watch app never loads UI  
**When:** First Watch run

**Solution:**
1. Check Watch is paired and unlocked
2. Verify Watch target membership for Watch views
3. Ensure Watch app has HealthKit capability
4. Check WatchKit Extension has correct entry point
5. Restart Watch and iPhone
6. Re-pair if necessary

---

### 15. "Failed to receive response from daemon"

**Symptom:** Watch connection error  
**When:** Running Watch app

**Solution:**
1. Xcode → Window → Devices and Simulators → Watch
2. Unpair and re-pair Watch simulator
3. For real device: Unpair Watch in iPhone Settings
4. Re-pair Watch via Watch app
5. Enable Developer Mode on Watch (Settings → Privacy → Developer Mode)

---

## 💳 RevenueCat Issues

### 16. "Invalid Product Identifier"

**Symptom:** Products don't load in paywall  
**When:** Testing purchases

**Solution:**
1. Go to App Store Connect → In-App Purchases
2. Verify product IDs match exactly (case-sensitive)
3. RevenueCat dashboard → Products → Check IDs
4. Ensure products are "Ready to Submit" status
5. Wait 2-4 hours after creating new products
6. Clear cache and restart app

---

### 17. "Unable to complete purchase" (Error code 2)

**Symptom:** Purchase fails  
**When:** Sandbox testing

**Solution:**
1. Sign out of real Apple ID in Settings
2. Don't sign in until prompted by purchase
3. When prompted, use Sandbox Tester email
4. Ensure Sandbox Tester exists in App Store Connect
5. Check region matches (US tester needs US app)
6. Delete app, reinstall, try again

---

### 18. RevenueCat initialization fails silently

**Symptom:** No offerings load, no error  
**When:** First launch

**Solution:**
Check initialization code:
```swift
import RevenueCat

// In app entry point (App.swift or scene delegate)
init() {
    Purchases.logLevel = .debug  // ← Add this for debugging
    Purchases.configure(withAPIKey: "your_api_key")
}
```
1. Verify API key is correct (check RevenueCat dashboard)
2. Check console for RevenueCat logs
3. Ensure internet connection available
4. Test on real device (sandbox requires device)

---

### 19. "Purchase not showing in RevenueCat dashboard"

**Symptom:** Completed purchase but no transaction in dashboard  
**When:** After test purchase

**Solution:**
1. Wait 1-2 minutes (webhook delay)
2. Check dashboard Customers → Search by user ID
3. Verify user ID is set:
```swift
Purchases.shared.logIn("user_id") { customerInfo, created in
    // Handle result
}
```
4. Check sandbox vs production API key
5. Verify bundle ID matches

---

### 20. "Restore purchases does nothing"

**Symptom:** Restore button doesn't restore subscription  
**When:** Testing restore flow

**Solution:**
Implement properly:
```swift
Purchases.shared.restorePurchases { customerInfo, error in
    if let error = error {
        print("Restore failed: \(error)")
        return
    }
    
    // Check customerInfo.entitlements for active subscriptions
    if customerInfo.entitlements["pro"]?.isActive == true {
        // User has active subscription
    }
}
```
1. Sign in with Sandbox Tester who made purchase
2. Must use same Apple ID as original purchase
3. Check for error in completion handler

---

## 🎯 Quick Diagnostics

### When build fails:
1. Read error message top to bottom
2. Check file has correct imports
3. Verify target membership
4. Clean build folder
5. Restart Xcode (seriously, sometimes helps)

### When app crashes:
1. Read console output
2. Check Info.plist for required keys
3. Set exception breakpoint (Debug → Breakpoints → Exception Breakpoint)
4. Run in Debug mode
5. Check for force-unwrapped nils (`!`)

### When RevenueCat fails:
1. Set `Purchases.logLevel = .debug`
2. Read console logs
3. Verify API key
4. Check product IDs match exactly
5. Wait 2-4 hours after creating products
6. Test on real device (not simulator)

### When Watch won't work:
1. Ensure Watch paired and unlocked
2. Check target membership
3. Enable Developer Mode on Watch
4. Restart both Watch and iPhone
5. Re-pair if all else fails

---

## 📞 Still Stuck?

**Check these guides:**
- INTEGRATION-ROADMAP.md (step-by-step process)
- REVENUECAT-INTEGRATION.md (detailed RevenueCat setup)
- XCODE-PROJECT-SETUP.md (project configuration)

**External resources:**
- [Apple Developer Forums](https://developer.apple.com/forums/)
- [RevenueCat Community](https://community.revenuecat.com/)
- [Stack Overflow - SwiftUI](https://stackoverflow.com/questions/tagged/swiftui)

**Nuclear option (last resort):**
1. Close Xcode
2. Delete DerivedData: `~/Library/Developer/Xcode/DerivedData`
3. Delete project's `.xcodeproj/project.xcworkspace`
4. Restart Mac
5. Open project and clean build

---

**Remember:** 95% of integration issues are:
1. Missing imports
2. Wrong target membership
3. Missing capabilities
4. Info.plist keys not added
5. Deployment target mismatch

Check these five things first before deep debugging! 🔍
