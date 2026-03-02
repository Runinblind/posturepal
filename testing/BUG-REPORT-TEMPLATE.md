# Bug Report Template

## Bug ID
`BUG-YYYY-MM-DD-###` (e.g., BUG-2024-01-15-001)

---

## Summary
_One-sentence description of the issue_

---

## Severity
- [ ] **Critical** - App crash, data loss, subscription failure, cannot use core feature
- [ ] **High** - Major feature broken, workaround exists but difficult
- [ ] **Medium** - Feature works incorrectly, impacts UX but not blocking
- [ ] **Low** - Minor visual issue, typo, cosmetic problem

---

## Priority
- [ ] **P0** - Blocker for release, fix immediately
- [ ] **P1** - Must fix before next release
- [ ] **P2** - Should fix soon (next sprint)
- [ ] **P3** - Nice to have, backlog

---

## Environment
- **Device:** _(e.g., iPhone 14 Pro)_
- **OS Version:** _(e.g., iOS 17.2)_
- **App Version:** _(e.g., 1.2.0 build 42)_
- **Watch:** _(if applicable, e.g., Apple Watch S7, watchOS 10.1)_
- **Subscription Status:** _(Free / Pro)_
- **Network:** _(WiFi / Cellular / Offline)_

---

## Steps to Reproduce
1. 
2. 
3. 
4. 

---

## Expected Behavior
_What should happen?_

---

## Actual Behavior
_What actually happens?_

---

## Reproduction Rate
- [ ] **100%** - Happens every time
- [ ] **High** - Happens most of the time (>75%)
- [ ] **Medium** - Happens sometimes (25-75%)
- [ ] **Low** - Happens rarely (<25%)
- [ ] **Cannot Reproduce** - Unable to reproduce consistently

---

## Screenshots / Videos
_Attach screenshots or screen recordings if applicable_

---

## Logs / Error Messages
```
Paste relevant console logs, crash reports, or error messages here
```

---

## Affected Features
_Which features are impacted?_
- [ ] Reminders
- [ ] Check-ins
- [ ] Streaks
- [ ] Watch app
- [ ] Widgets
- [ ] Subscription
- [ ] Settings
- [ ] Analytics
- [ ] Notifications
- [ ] Other: _______

---

## User Impact
- **Estimated Users Affected:** _(e.g., All users, Pro users only, 10%)_
- **Business Impact:** _(e.g., Blocks revenue, poor App Store reviews)_

---

## Workaround
_Is there a temporary workaround?_

---

## Root Cause (if known)
_Technical analysis of the issue_

---

## Fix Notes
_For developer use - link to PR, commit, or notes on the fix_

---

## Verification Steps
_How to verify the fix works_
1. 
2. 
3. 

---

## Related Issues
_Link to related bugs or features_
- 

---

## Additional Notes
_Any other relevant information_

---

## Metadata
- **Reported By:** _Name/Email_
- **Date Reported:** _YYYY-MM-DD_
- **Assigned To:** _Developer name_
- **Status:** _(Open / In Progress / Fixed / Closed / Won't Fix)_
- **Date Fixed:** _YYYY-MM-DD_
- **Fixed In Version:** _e.g., 1.2.1_

---

## Example Bug Report

### Bug ID
BUG-2024-01-15-001

### Summary
Watch app check-in does not sync to iPhone when offline

### Severity
- [x] High

### Priority
- [x] P1

### Environment
- Device: iPhone 13
- OS: iOS 17.2
- App Version: 1.1.0 (build 38)
- Watch: Apple Watch S6, watchOS 10.1
- Subscription: Pro
- Network: Offline (airplane mode)

### Steps to Reproduce
1. Enable airplane mode on both iPhone and Watch
2. Open PosturePal on Watch
3. Tap "Check In" button
4. Wait for confirmation
5. Disable airplane mode
6. Open PosturePal on iPhone
7. Check today's check-in count

### Expected Behavior
Check-in performed on Watch should sync to iPhone once network is restored

### Actual Behavior
Check-in remains on Watch only, iPhone shows 0 check-ins for today

### Reproduction Rate
- [x] 100%

### Logs
```
[CoreData] Failed to save context: Error Domain=NSCocoaErrorDomain Code=133020
[WatchConnectivity] Background transfer failed: session inactive
```

### Affected Features
- [x] Watch app
- [x] Check-ins
- [x] Streaks

### User Impact
- Estimated Users Affected: All Watch users in offline mode (~30%)
- Business Impact: Breaks core feature, may cause negative reviews

### Workaround
Perform check-in from iPhone instead of Watch when offline

### Root Cause
Watch Connectivity background transfer not queued when offline; needs local queue with retry logic

### Fix Notes
PR #47 - Implemented local CoreData sync queue with retry mechanism

### Verification Steps
1. Repeat reproduction steps
2. Verify check-in syncs after 30 seconds of connectivity
3. Verify no duplicate check-ins created

### Metadata
- Reported By: Beta Tester #12
- Date Reported: 2024-01-15
- Assigned To: Dev Lead
- Status: Fixed
- Date Fixed: 2024-01-18
- Fixed In Version: 1.1.1
