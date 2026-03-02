# Xcode Project Setup Guide - PosturePal Pro

Complete guide for creating the Xcode project and integrating all generated code.

**Prerequisites:** All code from Weeks 1-5 complete, RevenueCat integration guide ready.

---

## Phase 1: Create New Xcode Project (10 minutes)

### Step 1: Create iOS App Project

1. **Open Xcode** → Create New Project
2. **Choose Template:** iOS → App
3. **Project Settings:**
   - Product Name: `PosturePal Pro`
   - Team: Your Apple Developer Team
   - Organization Identifier: `com.yourcompany`
   - Bundle Identifier: `com.yourcompany.posturepal` (must match App Store Connect)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **Core Data** ✅ (check this!)
   - Tests: ✅ Include Unit Tests, ✅ Include UI Tests
4. **Save Location:** Choose project directory
5. Click **Create**

### Step 2: Add Watch App Target

1. **File** → **New** → **Target**
2. **Choose:** watchOS → Watch App
3. **Settings:**
   - Product Name: `PosturePal Watch`
   - Bundle Identifier: `com.yourcompany.posturepal.watchkitapp`
   - Include Notification Scene: ✅ Yes
4. **Activate Scheme:** Click "Activate" when prompted
5. Click **Finish**

### Step 3: Add Widget Extension Target

1. **File** → **New** → **Target**
2. **Choose:** iOS → Widget Extension
3. **Settings:**
   - Product Name: `PosturePalWidget`
   - Bundle Identifier: `com.yourcompany.posturepal.widgets`
   - Include Configuration Intent: ✅ Yes
4. **Activate Scheme:** Click "Activate"
5. Click **Finish**

---

## Phase 2: Configure Capabilities (5 minutes)

### For Main App Target

1. **Select Project** → **Targets** → **PosturePal Pro**
2. **Signing & Capabilities** tab
3. **Add Capabilities:**
   - ➕ Push Notifications
   - ➕ Background Modes → Enable **Background fetch** + **Remote notifications**
   - ➕ App Groups → Create: `group.com.yourcompany.posturepal`
   - ➕ HealthKit (optional for posture data)

### For Watch App Target

1. **Select** → **PosturePal Watch**
2. **Add Capabilities:**
   - ➕ Push Notifications
   - ➕ App Groups → Use same: `group.com.yourcompany.posturepal`

### For Widget Target

1. **Select** → **PosturePalWidget**
2. **Add Capabilities:**
   - ➕ App Groups → Use same: `group.com.yourcompany.posturepal`

---

## Phase 3: Add Swift Packages (5 minutes)

1. **File** → **Add Package Dependencies**
2. **Add RevenueCat:**
   - URL: `https://github.com/RevenueCat/purchases-ios-spm.git`
   - Dependency Rule: **Up to Next Major Version** (5.x.x)
   - Add to targets: **PosturePal Pro** (main app only)
   - Products: `RevenueCat` + `RevenueCatUI`
3. Click **Add Package**

---

## Phase 4: Import Generated Code (30 minutes)

### Organization Structure

Create folder groups in Xcode (right-click → New Group):

```
PosturePal Pro/
├── App/
│   └── PosturePalApp.swift
├── Models/
│   ├── UserSettings.swift
│   ├── CheckIn.swift
│   └── StreakData.swift
├── Services/
│   ├── NotificationService.swift
│   ├── CoreDataManager.swift
│   ├── PhoneConnectivityManager.swift
│   └── SubscriptionManager.swift
├── ViewModels/
│   ├── DashboardViewModel.swift
│   ├── SettingsViewModel.swift
│   └── AnalyticsViewModel.swift
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Dashboard/
│   │   └── DashboardView.swift
│   ├── Settings/
│   │   └── SettingsView.swift
│   ├── Analytics/
│   │   └── AnalyticsView.swift
│   ├── Subscription/
│   │   ├── PaywallView.swift
│   │   └── CustomerCenterView.swift
│   └── Components/
│       └── ConfettiView.swift
├── Resources/
│   ├── Assets.xcassets
│   └── Sounds/
└── PosturePal_Pro.xcdatamodeld

PosturePal Watch/
├── PosturePalWatchApp.swift
├── WatchConnectivityManager.swift
├── WatchDashboardViewModel.swift
└── WatchDashboardView.swift

PosturePalWidget/
├── PosturePalWidget.swift
└── WidgetBundle.swift
```

### Import Files

**From generated code:**
1. Copy all `.swift` files from `src/` folders
2. **Add to Xcode:** Right-click target folder → **Add Files to "PosturePal Pro"**
3. **Important:** Ensure correct target membership:
   - Main app files → **PosturePal Pro** target
   - Watch files → **PosturePal Watch** target
   - Widget files → **PosturePalWidget** target

**For each file:**
- Select file in Project Navigator
- Check **File Inspector** (right panel)
- Verify **Target Membership** checkboxes

---

## Phase 5: Configure Info.plist (10 minutes)

### Main App Info.plist

Add these keys:

```xml
<key>NSUserNotificationsUsageDescription</key>
<string>PosturePal needs notifications to remind you to check your posture throughout the day.</string>

<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<key>NSHealthShareUsageDescription</key>
<string>PosturePal can track your posture improvements alongside your health data (optional).</string>

<key>NSHealthUpdateUsageDescription</key>
<string>PosturePal can log your check-ins to HealthKit (optional).</string>

<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

### Watch Info.plist

Add:

```xml
<key>WKWatchOnly</key>
<false/>

<key>WKCompanionAppBundleIdentifier</key>
<string>com.yourcompany.posturepal</string>
```

---

## Phase 6: Configure CoreData (5 minutes)

1. Open `PosturePal_Pro.xcdatamodeld`
2. **Add Entities:**

**UserSettings** (Entity)
- `id` (UUID, optional: false)
- `reminderInterval` (Integer 32, default: 60)
- `notificationsEnabled` (Boolean, default: true)
- `hapticEnabled` (Boolean, default: true)
- `selectedSound` (String, default: "default")
- `quietHoursStart` (Date, optional: true)
- `quietHoursEnd` (Date, optional: true)

**CheckIn** (Entity)
- `id` (UUID, optional: false)
- `timestamp` (Date, optional: false)
- `note` (String, optional: true)

**StreakData** (Entity)
- `id` (UUID, optional: false)
- `currentStreak` (Integer 32, default: 0)
- `longestStreak` (Integer 32, default: 0)
- `lastCheckIn` (Date, optional: true)
- `totalCheckIns` (Integer 64, default: 0)

3. **Set Codegen:**
   - Select each entity → Data Model Inspector
   - Codegen: **Manual/None** (we're providing our own models)

---

## Phase 7: Update App Entry Point (5 minutes)

Replace `PosturePalApp.swift` content with:

```swift
import SwiftUI
import RevenueCat

@main
struct PosturePalApp: App {
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @StateObject private var connectivityManager = PhoneConnectivityManager.shared
    
    init() {
        // Configure RevenueCat
        Purchases.logLevel = .debug // Change to .info for production
        Purchases.configure(
            withAPIKey: "test_ronYRNgSkdhJsnoOhKqCzRjMcoH", // Replace with production key before release
            appUserID: nil
        )
        
        // Configure notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted")
            } else {
                print("❌ Notification permission denied: \(error?.localizedDescription ?? "unknown")")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(subscriptionManager)
                .environmentObject(connectivityManager)
        }
    }
}
```

---

## Phase 8: Build & Resolve Issues (20 minutes)

### First Build Attempt

1. **Select Scheme:** PosturePal Pro (iPhone simulator)
2. **Product** → **Clean Build Folder** (⌘⇧K)
3. **Product** → **Build** (⌘B)

### Common Issues & Fixes

**Issue:** "Cannot find type 'X' in scope"
- **Fix:** Check file is added to correct target
- Verify import statements

**Issue:** "Ambiguous use of 'X'"
- **Fix:** Ensure no duplicate files
- Check for naming conflicts

**Issue:** "Use of undeclared type 'Purchases'"
- **Fix:** Verify RevenueCat package is added
- Clean and rebuild

**Issue:** CoreData errors
- **Fix:** Ensure `.xcdatamodeld` is in main target
- Verify entity names match code

**Issue:** Widget extension errors
- **Fix:** Ensure App Group capability matches across targets
- Verify Widget target has correct bundle ID

---

## Phase 9: Test on Simulator (10 minutes)

### Run Main App

1. **Select:** iPhone 15 Pro simulator
2. **Product** → **Run** (⌘R)
3. **Verify:**
   - App launches without crashes
   - Onboarding appears
   - Can navigate to Dashboard
   - Can open Settings
   - Subscription manager initializes

### Run Watch App

1. **Select:** Apple Watch Series 9 (paired with iPhone 15 Pro)
2. **Scheme:** PosturePal Watch
3. **Product** → **Run**
4. **Verify:**
   - Watch app launches
   - Shows streak count
   - Can trigger check-in

### Test Widget

1. **Run main app** on simulator
2. **Long-press Home Screen** → **Add Widget**
3. **Find:** PosturePal
4. **Add widget** to Home Screen
5. **Verify:** Shows streak count

---

## Phase 10: Device Testing Preparation (5 minutes)

### Connect Physical Device

1. **Plug in iPhone** via USB
2. **Select device** in Xcode (top toolbar)
3. **Signing:**
   - Select project → Targets → PosturePal Pro
   - Signing & Capabilities
   - Team: Select your developer account
   - Automatically manage signing: ✅
4. **Build & Run** on physical device

### Pair Apple Watch

1. **iPhone Watch app** → Pair new watch
2. **Xcode** → Window → Devices and Simulators
3. **Verify watch appears** as paired
4. **Run Watch app** on physical watch

---

## Phase 11: Sandbox Testing (15 minutes)

### Configure Sandbox Tester

1. **App Store Connect** → Users and Access → Sandbox Testers
2. **Create new tester** (test Apple ID)
3. **iPhone Settings** → Sign out of Apple ID (iTunes only, not iCloud)

### Test Subscription Flow

1. **Run app** on device
2. **Navigate to** subscription screen
3. **Tap subscription** button
4. **Sign in** with sandbox tester when prompted
5. **Complete purchase** (no charge)
6. **Verify:**
   - Purchase succeeds
   - Pro features unlock
   - Customer Center shows subscription

---

## Phase 12: Pre-Submission Checklist (10 minutes)

Before TestFlight/App Store submission:

- [ ] All code compiles without warnings
- [ ] App runs on physical iPhone
- [ ] Watch app runs on physical Apple Watch
- [ ] Widgets display correctly
- [ ] Subscriptions work in sandbox
- [ ] No crashes during normal use
- [ ] All assets added (app icon, launch screen)
- [ ] Privacy policy URL added
- [ ] Terms of service URL added
- [ ] Support email configured
- [ ] Replace test RevenueCat key with production key
- [ ] Set Purchases.logLevel to `.info`
- [ ] Archive builds successfully
- [ ] Build number incremented

---

## Phase 13: TestFlight Beta (External Guide)

See Apple's official guide: https://developer.apple.com/testflight/

**Quick Steps:**
1. **Product** → **Archive**
2. **Organizer** → **Distribute App**
3. **App Store Connect** → Upload
4. **App Store Connect** → TestFlight → Add testers
5. **Send to beta testers**
6. **Collect feedback**
7. **Iterate and fix bugs**

---

## Troubleshooting

### Build Fails

**Check:**
1. Clean Build Folder (⌘⇧K)
2. Delete DerivedData: `~/Library/Developer/Xcode/DerivedData`
3. Restart Xcode
4. Verify all Swift files have correct target membership
5. Check for syntax errors in generated code

### App Crashes on Launch

**Check:**
1. Xcode console for error messages
2. CoreData model matches entity definitions
3. RevenueCat API key is valid
4. All required Info.plist entries added

### Watch App Not Appearing

**Check:**
1. iPhone and Watch are paired
2. Watch target bundle ID is correct (includes `.watchkitapp`)
3. WKCompanionAppBundleIdentifier matches main app
4. Both apps signed with same team

### Widgets Not Updating

**Check:**
1. App Group capability enabled on all targets
2. App Group identifier matches exactly (case-sensitive)
3. Widget extension has correct bundle ID
4. Timeline provider is configured correctly

---

## Next Steps After Setup

Once Xcode project is running:

1. **Manual Testing:** Follow QA test plan
2. **Bug Fixes:** Address any issues found
3. **Performance:** Profile with Instruments
4. **TestFlight:** Upload beta build
5. **Beta Testing:** Gather feedback from users
6. **Polish:** Final refinements
7. **Submission:** Submit to App Store
8. **Launch:** Execute marketing plan

---

## Resources

- **Xcode Help:** https://developer.apple.com/documentation/xcode
- **SwiftUI Tutorials:** https://developer.apple.com/tutorials/swiftui
- **RevenueCat Setup:** https://www.revenuecat.com/docs/getting-started/installation/ios
- **TestFlight Guide:** https://developer.apple.com/testflight/
- **App Store Guidelines:** https://developer.apple.com/app-store/review/guidelines/

---

**Estimated Total Time:** 2-3 hours for complete Xcode setup and first successful build

**Location:** `~/.openclaw/workspace/projects/jarvis-app-dev/projects/posture-app/`  
**Status:** Ready to follow when code generation completes
