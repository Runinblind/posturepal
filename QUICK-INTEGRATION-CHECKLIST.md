# PosturePal Pro - Quick Integration Checklist

**Print this page and check off tasks as you go. 6-8 hours total.**

---

## ☑️ Phase 1: Xcode Project (2-3 hours)

### Create Project
- [ ] New iOS App in Xcode (SwiftUI, Swift)
- [ ] Name: "PosturePal Pro"
- [ ] Select team & bundle ID
- [ ] Enable Git

### Add Targets
- [ ] Add Watch App target
- [ ] Add Widget Extension target
- [ ] Include Configuration Intent for widget

### Import Code
- [ ] Create folder structure (App, Core, Features, Services, Utils, Components, Resources)
- [ ] Drag 29 Swift files into Xcode
- [ ] **CRITICAL**: Check target membership for EVERY file
- [ ] Verify all files show (no red names)

### Configure Capabilities

**iOS App:**
- [ ] HealthKit
- [ ] Push Notifications
- [ ] Background Modes (fetch + remote notifications)
- [ ] In-App Purchase

**Watch App:**
- [ ] HealthKit
- [ ] Push Notifications

**Widget:**
- [ ] App Groups: `group.com.yourcompany.posturepal`

### Info.plist
- [ ] Add NSHealthShareUsageDescription (iOS)
- [ ] Add NSHealthUpdateUsageDescription (iOS)
- [ ] Add UIBackgroundModes array (iOS)
- [ ] Add NSHealthShareUsageDescription (Watch)

### First Build
- [ ] Clean Build Folder (Cmd+Shift+K)
- [ ] Build (Cmd+B)
- [ ] **Expect**: RevenueCat errors ONLY (normal at this stage)

---

## ☑️ Phase 2: RevenueCat (1 hour)

### Add Package
- [ ] File → Add Package Dependencies
- [ ] URL: `https://github.com/RevenueCat/purchases-ios`
- [ ] Add to iOS target only (not Watch/Widget)
- [ ] Wait for download

### Configure Dashboard
- [ ] Go to https://app.revenuecat.com
- [ ] Create project
- [ ] Copy iOS API Key
- [ ] Create Products (monthly, yearly)
- [ ] Create Offerings

### Initialize in Code
- [ ] Add initialization in app entry point
- [ ] Configure user ID (see REVENUECAT-INTEGRATION.md)
- [ ] Set up purchase listeners

### Test Sandbox
- [ ] Create Sandbox Tester in App Store Connect
- [ ] Sign out of Apple ID on device
- [ ] Run app and test purchase
- [ ] Verify in RevenueCat dashboard

---

## ☑️ Phase 3: Build & Fix (2-3 hours)

### Build Again
- [ ] Clean Build Folder
- [ ] Build (Cmd+B)
- [ ] Note all errors

### Fix Common Errors
- [ ] Missing imports? Add `import SwiftUI`, `import HealthKit`
- [ ] Widget errors? Check target membership
- [ ] Asset catalog? Create AppIcon set
- [ ] Bundle ID issues? Check Signing & Capabilities
- [ ] Deployment target? Set iOS 16.0 minimum

### Test on Simulator
- [ ] Run on iPhone simulator
- [ ] Check console for errors
- [ ] Test basic navigation
- [ ] Verify onboarding shows

### Test Watch
- [ ] Run on Watch simulator
- [ ] Verify UI loads
- [ ] Check data sync

### Final Checks
- [ ] iOS app: 0 build errors ✅
- [ ] Watch app: 0 build errors ✅
- [ ] Widget: 0 build errors ✅
- [ ] Runs without crashing ✅

---

## ☑️ Phase 4: Device Testing (1 hour)

### Setup iPhone
- [ ] Connect via USB
- [ ] Trust device
- [ ] Verify in Xcode Devices window
- [ ] Check iOS version (16.0+)

### Setup Watch
- [ ] Pair Watch to iPhone
- [ ] Enable Developer Mode (if iOS 16+)
- [ ] Verify in Xcode device list

### Sandbox Tester
- [ ] Create in App Store Connect
- [ ] Save credentials

### Run on Device
- [ ] Select iPhone device
- [ ] Resolve signing if needed
- [ ] Run (Cmd+R)
- [ ] Grant HealthKit permission
- [ ] Grant Notifications permission

### Test Purchase
- [ ] Sign out of Apple ID
- [ ] Sign in with Sandbox Tester
- [ ] Complete test purchase
- [ ] Verify unlock
- [ ] Check RevenueCat dashboard

---

## ✅ Final Verification

- [ ] iOS app runs on device
- [ ] Watch app runs on Watch
- [ ] All permissions granted
- [ ] Sandbox purchase works
- [ ] No crashes during use
- [ ] RevenueCat shows transaction
- [ ] Basic features work
- [ ] Ready for alpha testing

---

## 🎯 Milestones

**After Phase 1:** Project exists with all code imported  
**After Phase 2:** RevenueCat working, sandbox purchase tested  
**After Phase 3:** Clean builds, runs on simulator  
**After Phase 4:** Runs on real devices, fully functional

---

## 🆘 If Stuck

**Build errors?** → TROUBLESHOOTING-COMMON-ISSUES.md  
**RevenueCat?** → REVENUECAT-INTEGRATION.md  
**Xcode setup?** → XCODE-PROJECT-SETUP.md

---

**Estimated Time: 6-8 hours from start to finish**

Print this, grab a coffee, and let's ship it! ☕️🚀
