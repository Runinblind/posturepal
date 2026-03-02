# PosturePal Pro - Integration Roadmap

**Total Estimated Time: 6-8 hours**

This roadmap guides you through integrating 7,302 lines of Swift code (29 files) into a working Xcode project with RevenueCat subscriptions.

---

## Phase 1: Xcode Project Creation (2-3 hours)

### Step 1: Create New Xcode Project (15 min)
- [ ] Open Xcode 15.0+
- [ ] File → New → Project
- [ ] Choose "iOS App" template
- [ ] Settings:
  - Product Name: `PosturePal Pro`
  - Team: Select your Apple Developer account
  - Organization Identifier: `com.yourcompany` (use your own)
  - Interface: SwiftUI
  - Language: Swift
  - **Include Tests: YES** (for unit tests)
- [ ] Choose save location
- [ ] Create Git repository: YES

### Step 2: Add Watch App Target (20 min)
- [ ] File → New → Target
- [ ] Choose "Watch App for iOS App"
- [ ] Product Name: `PosturePal Pro Watch App`
- [ ] Ensure it's linked to your iOS app
- [ ] Xcode will create WatchApp folder automatically

### Step 3: Add Widget Extension (15 min)
- [ ] File → New → Target
- [ ] Choose "Widget Extension"
- [ ] Product Name: `PosturePalWidgets`
- [ ] Include Configuration Intent: YES
- [ ] Xcode creates WidgetExtension folder

### Step 4: Project Structure Setup (30 min)
Create these folders in Xcode (right-click project → New Group):

```
PosturePal Pro/
├── App/
│   ├── PosturePal_ProApp.swift
│   └── AppDelegate.swift (if needed)
├── Core/
│   ├── Models/
│   ├── ViewModels/
│   └── Managers/
├── Features/
│   ├── Onboarding/
│   ├── Dashboard/
│   ├── Settings/
│   └── Analytics/
├── Components/
│   └── Shared UI elements
├── Services/
│   ├── HealthKit/
│   ├── Notifications/
│   └── RevenueCat/
├── Utils/
│   ├── Extensions/
│   └── Helpers/
└── Resources/
    ├── Assets.xcassets
    └── Localizable.strings

PosturePal Pro Watch App/
├── Views/
├── ViewModels/
└── Complications/

PosturePalWidgets/
├── Widgets/
├── Providers/
└── Entries/
```

### Step 5: Import Swift Files (45 min)
- [ ] Drag all 29 Swift files from your code folder into appropriate groups
- [ ] **CRITICAL**: When import dialog appears:
  - ✅ Copy items if needed
  - ✅ Create groups (not folder references)
  - ✅ Add to targets: Check ALL relevant targets for each file
- [ ] Verify target membership for each file (File Inspector → Target Membership)

**Common target assignments:**
- Core models: iOS App + Watch App + Widget
- View files: iOS App only (unless Watch views)
- ViewModels: iOS App (+ Watch if shared)
- Widgets: Widget Extension only
- Watch views: Watch App only

### Step 6: Configure Capabilities (20 min)

**iOS App Target:**
- [ ] Signing & Capabilities tab
- [ ] Click "+ Capability"
- [ ] Add:
  - HealthKit
  - Push Notifications
  - Background Modes (Background fetch, Remote notifications)
  - In-App Purchase
- [ ] Verify Bundle Identifier matches App Store Connect

**Watch App Target:**
- [ ] Add HealthKit capability
- [ ] Add Push Notifications

**Widget Extension:**
- [ ] App Groups (for shared data)
  - Add group: `group.com.yourcompany.posturepal`
  - Update in code if different

### Step 7: Configure Info.plist (15 min)

**iOS App Info.plist additions:**
```xml
<key>NSHealthShareUsageDescription</key>
<string>PosturePal needs access to your posture and movement data to provide personalized insights.</string>

<key>NSHealthUpdateUsageDescription</key>
<string>PosturePal records your posture sessions to track progress.</string>

<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

**Watch App Info.plist:**
```xml
<key>NSHealthShareUsageDescription</key>
<string>Track posture data on your wrist.</string>
```

### Expected Errors & Solutions

**Error: "No such module 'RevenueCat'"**
→ Solution: Complete Phase 2 first (SPM dependency)

**Error: "Use of undeclared type 'WidgetKit'"**
→ Solution: Check target membership, ensure file is in Widget Extension target

**Error: "Cannot find 'HealthKit' in scope"**
→ Solution: Add HealthKit capability, import HealthKit in file

**Error: Multiple app delegate implementations**
→ Solution: PosturePal uses SwiftUI lifecycle, remove old AppDelegate if present

**Error: Duplicate symbols**
→ Solution: Check if files are added to multiple targets incorrectly

### Verification Checklist
- [ ] All 29 files visible in Xcode navigator
- [ ] No red file names (missing files)
- [ ] Each file has correct target membership
- [ ] All capabilities added and enabled
- [ ] Info.plist entries added
- [ ] Project builds (Cmd+B) - expect RevenueCat errors only

---

## Phase 2: RevenueCat Integration (1 hour)

### Step 1: Add RevenueCat via Swift Package Manager (10 min)
- [ ] File → Add Package Dependencies
- [ ] Enter URL: `https://github.com/RevenueCat/purchases-ios`
- [ ] Dependency Rule: "Up to Next Major Version" 4.0.0 < 5.0.0
- [ ] Click "Add Package"
- [ ] Select targets:
  - ✅ PosturePal Pro (iOS App)
  - ❌ Watch App (not needed)
  - ❌ Widget (not needed)
- [ ] Wait for SPM to resolve and download

### Step 2: Configure RevenueCat (15 min)
- [ ] Go to https://app.revenuecat.com
- [ ] Create project (if not exists): "PosturePal Pro"
- [ ] Copy API Keys:
  - iOS API Key (public)
  - Optional: Sandbox API Key for testing
- [ ] Create Products & Offerings (see REVENUECAT-INTEGRATION.md for details)

### Step 3: Initialize RevenueCat in App (20 min)
Follow the detailed guide in `REVENUECAT-INTEGRATION.md`:
- [ ] Add initialization code to app entry point
- [ ] Configure user identification
- [ ] Set up purchase listeners
- [ ] Implement restore purchases

### Step 4: Test Sandbox Purchase (15 min)
- [ ] Create Sandbox Tester in App Store Connect
- [ ] Sign out of real Apple ID in Settings
- [ ] Run app on device
- [ ] Navigate to paywall
- [ ] Attempt test purchase
- [ ] Verify receipt validation in RevenueCat dashboard

### Verification Checklist
- [ ] RevenueCat initializes without errors
- [ ] Can fetch offerings
- [ ] Test purchase completes (sandbox)
- [ ] Purchase shows in RevenueCat dashboard
- [ ] Restore purchases works

---

## Phase 3: First Build & Fixes (2-3 hours)

### Step 1: Clean Build (10 min)
- [ ] Product → Clean Build Folder (Cmd+Shift+K)
- [ ] Product → Build (Cmd+B)
- [ ] Note all errors in order

### Common Build Errors & Fixes

#### Error: Missing SwiftUI imports
```
Cannot find type 'View' in scope
```
**Fix:** Add `import SwiftUI` to top of file

#### Error: HealthKit types undefined
```
Cannot find 'HKQuantityType' in scope
```
**Fix:** Add `import HealthKit` to file

#### Error: Widget configuration issues
```
'StaticConfiguration' requires WidgetBundle
```
**Fix:** Ensure widget files have `import WidgetKit` and `import SwiftUI`

#### Error: Asset catalog missing
```
Cannot find 'AppIcon' in asset catalog
```
**Fix:** 
1. Select Assets.xcassets
2. Right-click → App Icons & Launch Images → New iOS App Icon
3. Add required icon sizes (use SF Symbols or temp placeholder)

#### Error: Bundle ID mismatch
```
Provisioning profile doesn't match bundle identifier
```
**Fix:** 
1. Check Signing & Capabilities
2. Ensure Bundle ID matches format: `com.yourcompany.posturepal`
3. Regenerate provisioning profile if needed

#### Error: Deployment target mismatch
```
Module compiled with Swift X.X cannot be imported
```
**Fix:**
1. Select Project → Build Settings
2. Search "iOS Deployment Target"
3. Set to iOS 16.0 minimum (for all targets)
4. Clean build folder and rebuild

### Step 2: Fix File Organization (30 min)
- [ ] Review each compiler error
- [ ] Check file is in correct group/folder
- [ ] Verify target membership (critical!)
- [ ] Fix import statements
- [ ] Resolve naming conflicts

### Step 3: Resolve Dependencies (45 min)
- [ ] Ensure all view models are accessible to views
- [ ] Check model files are in shared targets if needed by Watch/Widget
- [ ] Verify extension files are in correct targets
- [ ] Fix any circular dependencies

### Step 4: Run on Simulator (30 min)
- [ ] Select iPhone simulator (iPhone 15 Pro recommended)
- [ ] Product → Run (Cmd+R)
- [ ] Watch console for runtime errors
- [ ] Test basic navigation
- [ ] Check that onboarding appears (first launch)

### Step 5: Test Watch App (30 min)
- [ ] Select Watch simulator (Apple Watch Series 9)
- [ ] Build and run Watch target
- [ ] Verify Watch UI loads
- [ ] Test complications (if implemented)
- [ ] Check data sync between iOS and Watch

### Verification Checklist
- [ ] iOS app builds successfully (0 errors)
- [ ] Watch app builds successfully
- [ ] Widget extension builds successfully
- [ ] iOS app runs on simulator without crashes
- [ ] Watch app loads and displays UI
- [ ] No critical console errors/warnings
- [ ] Basic navigation works

---

## Phase 4: Device Testing Prep (1 hour)

### Step 1: iPhone Setup (20 min)
- [ ] Connect iPhone via USB
- [ ] Trust computer (if first time)
- [ ] Xcode → Window → Devices and Simulators
- [ ] Verify device appears and is trusted
- [ ] Check iOS version (16.0+ required)
- [ ] If needed, update iOS

### Step 2: Watch Pairing (15 min)
- [ ] Ensure Watch is paired to iPhone
- [ ] Watch app installed automatically (or manually via Watch app)
- [ ] Verify watch shows in Xcode device list
- [ ] Enable Developer Mode on Watch (if iOS 16+)

### Step 3: Sandbox Tester Creation (10 min)
- [ ] Go to App Store Connect
- [ ] Users and Access → Sandbox Testers
- [ ] Click "+" to add tester
- [ ] Use unique email (doesn't need to exist)
- [ ] Set region (match App Store region)
- [ ] Save credentials securely

### Step 4: Device Build & Run (15 min)
- [ ] Select iPhone device in Xcode
- [ ] Ensure signing is configured (may need to resolve)
- [ ] Product → Run (Cmd+R)
- [ ] Approve "Developer Mode" if prompted
- [ ] App installs and launches
- [ ] Test basic flows
- [ ] Check HealthKit permissions prompt

### Step 5: First Real Purchase Test (Optional, 10 min)
- [ ] Sign out of Apple ID in Settings
- [ ] Sign in with Sandbox Tester account
- [ ] Launch PosturePal Pro
- [ ] Navigate to subscription screen
- [ ] Tap subscribe
- [ ] Complete sandbox purchase
- [ ] Verify unlock in app
- [ ] Check RevenueCat dashboard shows transaction

### Verification Checklist
- [ ] App runs on physical iPhone
- [ ] Watch app runs on paired Watch
- [ ] HealthKit permissions granted
- [ ] Notifications permission granted (if prompted)
- [ ] Sandbox purchase completes successfully
- [ ] No crashes during basic usage
- [ ] Data syncs between iPhone and Watch

---

## Milestone Checklist

### 🎯 Milestone 1: Project Created (End of Phase 1)
- [ ] Xcode project with 3 targets (iOS, Watch, Widget)
- [ ] All 29 Swift files imported
- [ ] Capabilities configured
- [ ] Project builds (with expected RevenueCat errors only)

### 🎯 Milestone 2: RevenueCat Integrated (End of Phase 2)
- [ ] SPM dependency added
- [ ] RevenueCat initialized
- [ ] Sandbox purchase tested
- [ ] Products configured in dashboard

### 🎯 Milestone 3: Builds Clean (End of Phase 3)
- [ ] All targets build with 0 errors
- [ ] Runs on simulator
- [ ] Basic navigation works
- [ ] No critical runtime errors

### 🎯 Milestone 4: Device Ready (End of Phase 4)
- [ ] Runs on physical iPhone
- [ ] Watch app functional
- [ ] Permissions working
- [ ] Ready for real testing

---

## Next Steps After Integration

Once all 4 phases complete:

1. **Alpha Testing** (1-2 days)
   - Dog-food the app yourself
   - Fix critical bugs
   - Polish UX issues

2. **TestFlight** (1 day)
   - Submit to TestFlight
   - Invite beta testers
   - Gather feedback

3. **App Store Submission** (2-3 days)
   - Prepare screenshots
   - Write App Store description
   - Submit for review

4. **Launch** 🚀

---

## Getting Help

**If stuck on:**
- **Build errors**: Check TROUBLESHOOTING-COMMON-ISSUES.md
- **RevenueCat**: See REVENUECAT-INTEGRATION.md
- **Xcode setup**: See XCODE-PROJECT-SETUP.md
- **General questions**: Create GitHub issue or contact support

**Resources:**
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [RevenueCat Docs](https://docs.revenuecat.com/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)

---

**Remember:** Integration is iterative. Don't panic if things don't work first try. Follow the roadmap, check off items, and debug systematically. You've got this! 💪
