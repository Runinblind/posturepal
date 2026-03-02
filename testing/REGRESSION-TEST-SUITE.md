# Regression Test Suite

## Purpose
Critical path tests that **must pass** before any release. These are the non-negotiable core flows that define PosturePal Pro.

**Test Execution:** 30-45 minutes on physical device  
**Frequency:** Before every release, after major changes  
**Pass Criteria:** 100% of critical tests must pass

---

## Critical Path Tests (Must Pass 100%)

### CP-001: First-Time User Journey
**User Story:** New user downloads app and completes first check-in

**Steps:**
1. Install app from TestFlight (clean install)
2. Launch app
3. Grant notification permissions when prompted
4. Complete onboarding flow
5. Set up first reminder (30 min interval)
6. Wait for notification (or trigger manually via debug)
7. Tap notification
8. Complete check-in from notification
9. Verify streak incremented to 1
10. Verify check-in recorded in history

**Pass Criteria:**
- Onboarding completes without crashes
- Notification appears at scheduled time
- Check-in recorded successfully
- Streak shows "1 day"
- UI updates in real-time

**Notes:** This is the most important test. If this fails, app is not shippable.

---

### CP-002: Subscription Purchase Flow
**User Story:** Free user upgrades to Pro subscription

**Steps:**
1. Launch app in free tier
2. Navigate to Settings → Upgrade to Pro
3. Review Pro features list
4. Tap "Subscribe" button
5. Verify App Store payment sheet appears
6. Complete purchase (Sandbox account)
7. Wait for purchase confirmation
8. Verify app updates to Pro status
9. Verify Pro badge appears in UI
10. Close and relaunch app
11. Verify Pro status persists

**Pass Criteria:**
- Payment sheet displays correctly
- Purchase succeeds without errors
- Entitlement grants immediately
- RevenueCat updates status
- Pro features unlock
- Status persists across restarts

**Notes:** Revenue-critical flow. Test with Sandbox accounts only.

---

### CP-003: Subscription Restore
**User Story:** Pro user reinstalls app and restores purchase

**Steps:**
1. Have active Pro subscription (from CP-002)
2. Delete app
3. Reinstall from TestFlight
4. Launch app
5. Navigate to Settings
6. Tap "Restore Purchases"
7. Wait for restore confirmation
8. Verify Pro status restored
9. Verify Pro features available

**Pass Criteria:**
- Restore button accessible to non-Pro users
- Restore succeeds with valid receipt
- Pro status updates immediately
- No duplicate charges occur

---

### CP-004: Watch App Check-In Sync
**User Story:** User performs check-in on Watch, syncs to iPhone

**Prerequisites:** Paired Apple Watch, PosturePal installed on both devices

**Steps:**
1. Open PosturePal on iPhone, verify current streak
2. Close iPhone app
3. Open PosturePal on Watch
4. Tap "Check In" button
5. Verify haptic feedback
6. Verify success message on Watch
7. Wait 10 seconds
8. Open PosturePal on iPhone
9. Verify check-in appears in history
10. Verify streak incremented

**Pass Criteria:**
- Watch app launches without errors
- Check-in button responsive
- Sync occurs within 30 seconds
- Data matches on both devices
- No duplicate check-ins created

---

### CP-005: Widget Updates After Check-In
**User Story:** User performs check-in, widgets update in real-time

**Prerequisites:** At least one widget added to Home Screen

**Steps:**
1. Add PosturePal widget to Home Screen (Medium size)
2. Note current streak count on widget
3. Open PosturePal app
4. Perform check-in
5. Return to Home Screen
6. Verify widget updates within 5 seconds
7. Verify streak count incremented
8. Verify "Last check-in: Just now"

**Pass Criteria:**
- Widget updates without manual refresh
- Data matches app state
- Update occurs within 5 seconds
- Layout remains correct

---

### CP-006: Streak Persistence Across Restart
**User Story:** User builds streak, force-quits app, streak persists

**Steps:**
1. Perform 3 check-ins over 3 days (or use test data)
2. Verify streak = 3
3. Force-quit app (swipe up in app switcher)
4. Wait 10 seconds
5. Relaunch app
6. Verify streak still = 3
7. Verify check-in history intact
8. Perform new check-in
9. Verify streak = 4

**Pass Criteria:**
- Streak count persists
- Check-in history intact
- CoreData saves successfully
- No data loss on restart

---

### CP-007: Notification Scheduling & Delivery
**User Story:** User sets reminder, notification fires on schedule

**Steps:**
1. Open PosturePal
2. Set reminder interval to 15 minutes
3. Start reminder
4. Note scheduled time
5. Close app (don't force-quit)
6. Wait 15 minutes
7. Verify notification appears
8. Tap notification
9. Verify app opens
10. Verify check-in screen shown

**Pass Criteria:**
- Notification fires within ±30 seconds of scheduled time
- Notification content correct (title, body)
- Tapping opens app to check-in flow
- Notification sound plays (if enabled)

**Notes:** Test both foreground and background delivery.

---

### CP-008: Offline Mode Core Functionality
**User Story:** User uses app with no network connection

**Steps:**
1. Enable airplane mode
2. Launch PosturePal
3. Perform check-in
4. Verify check-in recorded locally
5. Verify streak incremented
6. Create new reminder
7. Verify reminder scheduled
8. Disable airplane mode
9. Wait 30 seconds
10. Verify data syncs (if applicable)

**Pass Criteria:**
- App launches offline
- Check-ins work without network
- Reminders schedule offline
- CoreData saves locally
- No crashes or blocking errors

---

### CP-009: Free Tier Limitations Enforced
**User Story:** Free user attempts to access Pro features

**Steps:**
1. Ensure app in free tier (not subscribed)
2. Attempt to create second reminder
3. Verify Pro paywall appears
4. Tap "Subscribe" (don't complete purchase)
5. Cancel and return
6. Attempt to use streak freeze
7. Verify Pro paywall appears
8. Attempt to export data
9. Verify Pro paywall appears

**Pass Criteria:**
- Free tier limits enforced
- Paywall appears for Pro features
- User cannot bypass restrictions
- No crashes when accessing locked features

---

### CP-010: Data Export (Pro Feature)
**User Story:** Pro user exports check-in history

**Prerequisites:** Pro subscription, at least 10 check-ins recorded

**Steps:**
1. Navigate to Settings → Export Data
2. Tap "Export as CSV"
3. Verify share sheet appears
4. Save to Files app
5. Open CSV in Files or Notes
6. Verify data format correct
7. Verify all check-ins present
8. Verify timestamps accurate

**Pass Criteria:**
- Export button accessible to Pro users
- CSV generates without errors
- Data format valid (parseable)
- All check-ins included
- Timestamps in readable format

---

## Cross-Device Sync Tests (If Applicable)

### CP-011: iPhone to Watch Sync
**Steps:**
1. Perform check-in on iPhone
2. Wait 10 seconds
3. Open Watch app
4. Verify data synced

**Pass Criteria:** Data syncs within 30 seconds

---

### CP-012: Watch to iPhone Sync
**Steps:**
1. Perform check-in on Watch
2. Wait 10 seconds
3. Open iPhone app
4. Verify data synced

**Pass Criteria:** Data syncs within 30 seconds

---

## Performance Regression Tests

### CP-013: App Launch Time
**Steps:**
1. Force-quit app
2. Launch app with timer
3. Measure time to interactive UI

**Pass Criteria:** < 2 seconds on iPhone 12 or newer

---

### CP-014: Memory Usage During Active Use
**Steps:**
1. Open app
2. Navigate through all screens
3. Perform 5 check-ins
4. Check Xcode Instruments memory graph

**Pass Criteria:** < 150 MB peak memory usage

---

## Test Execution Log Template

```
Date: YYYY-MM-DD
Tester: [Name]
Device: [Model, OS version]
App Version: [Version + build]

| Test ID | Pass/Fail | Notes |
|---------|-----------|-------|
| CP-001  |           |       |
| CP-002  |           |       |
| CP-003  |           |       |
| CP-004  |           |       |
| CP-005  |           |       |
| CP-006  |           |       |
| CP-007  |           |       |
| CP-008  |           |       |
| CP-009  |           |       |
| CP-010  |           |       |
| CP-011  |           |       |
| CP-012  |           |       |
| CP-013  |           |       |
| CP-014  |           |       |

Overall: [PASS / FAIL]
Blocker Issues: [List any blocking bugs]
```

---

## Release Decision Matrix

| Critical Tests Passed | Performance Tests Passed | Decision |
|----------------------|--------------------------|----------|
| 100% | 100% | ✅ **Ship it** |
| 100% | < 100% | ⚠️ **Ship with known issues** (document in release notes) |
| 90-99% | Any | 🔶 **Conditional ship** (assess impact of failures) |
| < 90% | Any | ❌ **Do not ship** (fix critical bugs first) |

---

## Notes
- Always test on physical devices, not just simulator
- Test both free and Pro tiers
- Test with and without Watch paired
- Document any flaky tests for investigation
- Update this suite as new critical paths emerge
