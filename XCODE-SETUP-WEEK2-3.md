# Xcode Project Setup - Week 2-3 (Watch + Widgets + RevenueCat)

**Last Updated:** 2026-03-01  
**Phase:** Week 2-3 Complete  
**Targets:** iOS App + Apple Watch App + Widget Extension

---

## Prerequisites

- macOS with Xcode 15.0+ installed
- Apple Developer account (for Watch app and App Groups)
- Physical Apple Watch (Watch app testing requires real hardware)
- iPhone running iOS 16.0+ and Watch running watchOS 9.0+

---

## Step 1: Create Base Xcode Project

### 1.1 Create New Project

1. Open Xcode
2. File → New → Project
3. Select **iOS** → **App**
4. Configure:
   - Product Name: `PosturePal`
   - Team: Select your Apple Developer team
   - Organization Identifier: `com.yourcompany` (or your domain)
   - Bundle Identifier: `com.yourcompany.posturepal`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **Core Data** ✅ (important!)
5. Save in: `~/Projects/PosturePal/`

### 1.2 Set Deployment Target

1. Select `PosturePal` target
2. General → Deployment Info
3. Set **Minimum Deployments:** `iOS 16.0`

---

## Step 2: Import Week 1 iPhone App Code

### 2.1 File Structure

In Finder:
```
~/Projects/PosturePal/
└── PosturePal/
    ├── Models/
    ├── ViewModels/
    ├── Views/
    │   ├── Onboarding/
    │   ├── Home/
    │   ├── Settings/
    │   ├── Paywall/         (NEW Week 2-3)
    │   └── Animations/      (NEW Week 2-3)
    ├── Services/
    ├── Subscription/        (NEW Week 2-3)
    └── PosturePalApp.swift
```

### 2.2 Copy Files

From downloaded source:

```bash
cd ~/Projects/PosturePal/PosturePal/

# Week 1 files
cp -r ~/path/to/src/Models ./
cp -r ~/path/to/src/ViewModels ./
cp -r ~/path/to/src/Views/Onboarding ./Views/
cp -r ~/path/to/src/Views/Home ./Views/
cp -r ~/path/to/src/Views/Settings ./Views/
cp -r ~/path/to/src/Services ./
cp ~/path/to/src/PosturePalApp.swift ./

# Week 2-3 files (NEW)
cp -r ~/path/to/src/Views/Paywall ./Views/
cp -r ~/path/to/src/Views/Animations ./Views/
cp -r ~/path/to/src/Subscription ./
```

### 2.3 Add to Xcode

1. Right-click `PosturePal` group in Project Navigator
2. Add Files to "PosturePal"...
3. Select all copied folders
4. Options:
   - ✅ Copy items if needed
   - ✅ Create groups
   - ✅ Add to target: PosturePal
5. Click Add

---

## Step 3: Create CoreData Model

### 3.1 Add CheckIn Entity

1. Click `PosturePal.xcdatamodeld` in Project Navigator
2. Click **Add Entity** (bottom toolbar)
3. Name: `CheckIn`
4. Add Attributes:
   - `id` → UUID → Required ✅
   - `timestamp` → Date → Required ✅ → Indexed ✅
   - `wasOnTime` → Boolean → Required ✅ → Default: `YES`

5. Select `CheckIn` entity → Data Model Inspector (right panel)
   - Codegen: **Manual/None**
   - Module: `PosturePal`

---

## Step 4: Enable App Groups (Required for Widgets)

### 4.1 Enable for iPhone App

1. Select `PosturePal` target
2. Signing & Capabilities tab
3. Click **+ Capability**
4. Select **App Groups**
5. Click **+** under App Groups
6. Enter: `group.com.yourcompany.posturepal` (replace yourcompany)
7. Click OK

> **Important:** The group identifier must match the one used in code (`group.com.posturepal.app` in current code). Either update the code to match your identifier, or use the exact identifier from the code.

---

## Step 5: Add Apple Watch App Target

### 5.1 Create Watch App

1. File → New → Target
2. Select **watchOS** → **Watch App**
3. Configure:
   - Product Name: `PosturePal Watch App`
   - Organization Identifier: Same as main app
   - Bundle Identifier: `com.yourcompany.posturepal.watchkitapp`
   - Deployment Target: **watchOS 9.0**
4. Click Finish
5. Activate "PosturePal Watch App" scheme: **Activate**

### 5.2 Enable App Groups for Watch App

1. Select `PosturePal Watch App` target
2. Signing & Capabilities
3. + Capability → App Groups
4. Enable same group: `group.com.yourcompany.posturepal`

### 5.3 Import Watch App Code

From downloaded source:

```bash
cd ~/Projects/PosturePal/PosturePal\ Watch\ App/

# Copy Watch app files
cp ~/path/to/src-watch/PosturePalWatchApp.swift ./
cp ~/path/to/src-watch/WatchConnectivityManager.swift ./
cp ~/path/to/src-watch/WatchDashboardViewModel.swift ./
cp ~/path/to/src-watch/WatchDashboardView.swift ./
```

Add to Xcode:
1. Right-click `PosturePal Watch App` group
2. Add Files...
3. Select all Watch Swift files
4. **Target:** PosturePal Watch App ✅

---

## Step 6: Add Widget Extension Target

### 6.1 Create Widget Extension

1. File → New → Target
2. Select **iOS** → **Widget Extension**
3. Configure:
   - Product Name: `PosturePalWidget`
   - Organization Identifier: Same as main app
   - Bundle Identifier: `com.yourcompany.posturepal.widget`
   - Include Configuration Intent: **NO** ❌
4. Click Finish
5. Activate "PosturePalWidget" scheme: **Activate**

### 6.2 Enable App Groups for Widget

1. Select `PosturePalWidget` target
2. Signing & Capabilities
3. + Capability → App Groups
4. Enable same group: `group.com.yourcompany.posturepal`

### 6.3 Import Widget Code

From downloaded source:

```bash
cd ~/Projects/PosturePal/PosturePalWidget/

# Copy widget file (replace default)
cp ~/path/to/src-widget/PosturePalWidget.swift ./PosturePalWidget.swift
```

Replace the default `PosturePalWidget.swift` that Xcode created.

---

## Step 7: Install RevenueCat SDK

### 7.1 Add Package Dependency

1. File → Add Package Dependencies...
2. Enter URL: `https://github.com/RevenueCat/purchases-ios.git`
3. Dependency Rule: **Up to Next Major Version** → `4.30.0`
4. Click Add Package
5. Select Package Products:
   - `RevenueCat` → Add to `PosturePal` target ✅
6. Click Add Package

### 7.2 Configure API Key

1. Sign up at [RevenueCat](https://app.revenuecat.com/)
2. Create new app
3. Copy API key
4. Open `SubscriptionManager.swift`
5. Replace:
   ```swift
   Purchases.configure(withAPIKey: "appl_XXXXXXXXXXXXX")
   ```
   with your actual API key

### 7.3 Configure Products in RevenueCat

1. RevenueCat Dashboard → Products
2. Add Products:
   - Product ID: `com.yourcompany.posturepal.premium.monthly`
   - Product ID: `com.yourcompany.posturepal.premium.annual`
3. Create Entitlement: `premium`
4. Add both products to `premium` entitlement

> **Note:** Product IDs in code must match exactly!

---

## Step 8: Configure Info.plist

### 8.1 iPhone App Info.plist

Add notification permission description:

```xml
<key>NSUserNotificationsUsageDescription</key>
<string>We'll send gentle reminders to check your posture throughout the day.</string>
```

### 8.2 Watch App Info.plist

Add notification permission:

```xml
<key>NSUserNotificationsUsageDescription</key>
<string>We'll send gentle reminders to check your posture throughout the day.</string>
```

---

## Step 9: Configure Build Settings

### 9.1 Fix Common Build Issues

For all targets (PosturePal, Watch App, Widget):

1. Build Settings → Search "Other Linker Flags"
2. Ensure `-ObjC` flag is present (RevenueCat requirement)

### 9.2 Set Deployment Targets

- **PosturePal (iOS):** 16.0
- **PosturePal Watch App:** watchOS 9.0
- **PosturePalWidget:** iOS 16.0

---

## Step 10: Build & Run

### 10.1 Select Scheme

- **iPhone App:** Select `PosturePal` scheme → iPhone simulator or device
- **Watch App:** Select `PosturePal Watch App` scheme → Paired Watch (real hardware required!)
- **Widget:** Widgets appear automatically after running iPhone app

### 10.2 First Build

1. Product → Build (⌘B)
2. Fix any build errors (usually import issues)
3. Product → Run (⌘R)

### 10.3 Common Build Errors

**Error:** `Cannot find 'PhoneConnectivityManager' in scope`

**Fix:** Ensure `PhoneConnectivityManager.swift` is added to `PosturePal` target (not Watch target)

---

**Error:** `Module 'RevenueCat' not found`

**Fix:** 
1. File → Add Packages
2. Add RevenueCat again
3. Ensure added to `PosturePal` target

---

**Error:** `App group identifier mismatch`

**Fix:** Update all `UserDefaults(suiteName:)` calls to match your actual App Group ID

---

## Step 11: Test on Physical Devices

### 11.1 iPhone Testing

1. Connect iPhone via USB
2. Select iPhone as destination
3. Xcode may prompt to register device → Click Register
4. Trust computer on iPhone if prompted
5. Run app

### 11.2 Apple Watch Testing

1. Ensure Watch is paired with iPhone
2. Open Xcode → Window → Devices and Simulators → Devices
3. Verify Watch appears under iPhone
4. Select `PosturePal Watch App` scheme
5. Select Paired Watch as destination
6. Run (may take 5-10 minutes first time)

### 11.3 Widget Testing

1. Run iPhone app once (installs widget extension)
2. Long-press home screen → "+" button
3. Search "PosturePal"
4. Add Small or Medium widget
5. Perform check-in in app → verify widget updates

---

## Step 12: Configure Schemes (Optional)

### 12.1 Create Combined Scheme

To run iPhone + Watch app simultaneously:

1. Product → Scheme → Manage Schemes
2. Click "+"
3. Name: `PosturePal + Watch`
4. Check both `PosturePal` and `PosturePal Watch App`
5. Click OK

Now you can run both with one click!

---

## Step 13: StoreKit Configuration (Sandbox Testing)

### 13.1 Create StoreKit Configuration File

1. File → New → File
2. Select **StoreKit Configuration File**
3. Name: `Subscriptions.storekit`
4. Click Create

### 13.2 Add Subscriptions

1. Click **+** → Add Auto-Renewable Subscription
2. Configure Monthly:
   - Reference Name: `PosturePal Premium Monthly`
   - Product ID: `com.yourcompany.posturepal.premium.monthly`
   - Price: $4.99
   - Subscription Duration: 1 Month
3. Configure Annual (repeat above with annual ID and $29.99)

### 13.3 Test Purchases

1. Edit Scheme → Run → Options
2. StoreKit Configuration: `Subscriptions.storekit`
3. Run app
4. Tap "Upgrade to Pro"
5. Purchase will use sandbox (no real money)

---

## 🎉 You're Done!

Your Xcode project now has:

✅ iOS app with all Week 1-3 features  
✅ Apple Watch companion app  
✅ Home screen and lock screen widgets  
✅ RevenueCat subscription integration  
✅ Confetti animations and polish  

### Next Steps:

1. **Customize branding:**
   - Replace "yourcompany" in all identifiers
   - Update RevenueCat product IDs in code

2. **Add app icon:**
   - Design 1024x1024 icon
   - Add to Assets.xcassets

3. **Test thoroughly:**
   - Check-in flow
   - Watch sync
   - Widget updates
   - Subscription purchases

4. **TestFlight:**
   - Archive → Upload to App Store Connect
   - Add testers → Collect feedback

---

**Stuck?** Check README-WEEK2-3.md for troubleshooting.

**Ready to launch?** See ARCHITECTURE.md Week 7-8 plan.

🚀 **Happy building!**
