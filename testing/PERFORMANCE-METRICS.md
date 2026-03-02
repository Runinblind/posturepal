# Performance Metrics & Benchmarks

## Overview
This document defines the performance targets, measurement methods, and acceptable thresholds for PosturePal Pro.

**Philosophy:** Fast, lightweight, respectful of user's battery and data.

---

## 1. App Launch Time

### Targets
| Metric | Target | Maximum | Measured On |
|--------|--------|---------|-------------|
| **Cold Launch** | 1.5s | 2.0s | iPhone 12, iOS 17 |
| **Warm Launch** | 0.6s | 1.0s | iPhone 12, iOS 17 |
| **After Notification Tap** | 1.0s | 1.5s | iPhone 12, iOS 17 |
| **Watch App Launch** | 1.0s | 1.5s | Apple Watch S6, watchOS 10 |

### Measurement Method
1. Force-quit app
2. Start timer
3. Tap app icon
4. Stop timer when main UI fully interactive (can tap check-in button)
5. Take average of 5 consecutive launches

### Xcode Instruments
- Use **Time Profiler** to identify bottlenecks
- Use **App Launch** template for detailed breakdown
- Target: <250ms pre-main, <1.5s post-main

### Optimization Checklist
- [ ] Lazy load non-critical views
- [ ] Defer heavy data loads to background
- [ ] Cache RevenueCat entitlement check
- [ ] Minimize CoreData fetches on launch
- [ ] Use `@StateObject` and `@ObservedObject` correctly
- [ ] Avoid synchronous network calls on launch

---

## 2. Memory Usage

### Targets
| State | Target | Maximum | Device |
|-------|--------|---------|--------|
| **Idle (background)** | 40 MB | 50 MB | iPhone 12 |
| **Active Use** | 80 MB | 100 MB | iPhone 12 |
| **Peak (intensive task)** | 120 MB | 150 MB | iPhone 12 |
| **Watch App** | 20 MB | 30 MB | Apple Watch S6 |
| **Widget (per instance)** | 15 MB | 20 MB | iPhone 12 |

### Measurement Method
1. Open Xcode → Debug Navigator → Memory
2. Launch app
3. Navigate through all screens
4. Perform 10 check-ins
5. Return to background
6. Monitor memory graph for leaks
7. Use **Instruments → Leaks** for detailed analysis

### Acceptable Behavior
- ✅ Memory usage should stabilize after initial load
- ✅ No continuous growth over time (memory leaks)
- ✅ Should release memory when backgrounded
- ⚠️ Spikes allowed during data export (brief)

### Red Flags
- ❌ Memory increases with each check-in (leak)
- ❌ Memory never released when backgrounded
- ❌ Sudden jumps >50 MB without user action
- ❌ Memory warnings in console

### Optimization Checklist
- [ ] Use `[weak self]` in closures
- [ ] Properly cancel Combine subscriptions
- [ ] Release large data structures when done
- [ ] Use `autoreleasepool` for batch operations
- [ ] Profile with Leaks instrument before release

---

## 3. Battery Impact

### Targets
| Activity | Target | Maximum | Notes |
|----------|--------|---------|-------|
| **Background (1 hour)** | 0.5% | 1.0% | Mostly idle, occasional sync |
| **Active use (10 min)** | 1.5% | 2.0% | Normal interaction |
| **Daily usage (typical)** | 3% | 5% | ~5 check-ins, 20 min total use |
| **Watch (24h)** | 3% | 5% | Paired, occasional sync |

### Measurement Method
1. Charge device to 100%
2. Disconnect charger
3. Use app for measured period (e.g., 10 min active)
4. Note battery % before and after
5. Repeat 3 times, average results
6. Account for background drain (subtract control measurement)

### Xcode Energy Log
- Use **Instruments → Energy Log** template
- Target: **Overhead Low** rating
- Avoid **Overhead High** warnings

### Battery Draining Activities
- ❌ Constant background refresh
- ❌ Continuous location tracking (not used)
- ❌ Persistent network connections
- ❌ Heavy CPU work in background

### Optimization Checklist
- [ ] Use `UNNotificationRequest` (local) instead of push
- [ ] Batch Watch Connectivity transfers
- [ ] Minimize widget refresh frequency (30 min interval)
- [ ] Avoid polling—use notifications/callbacks
- [ ] Profile with Energy Log before release

---

## 4. Network Usage

### Targets
| Activity | Target | Maximum | Notes |
|----------|--------|---------|-------|
| **Subscription Check** | 20 KB | 50 KB | RevenueCat API call |
| **Analytics Sync** | 50 KB | 100 KB | Daily aggregated events |
| **Initial RevenueCat Setup** | 100 KB | 200 KB | First launch only |
| **Daily Total (typical)** | 100 KB | 250 KB | All network activity |

### Measurement Method
1. Settings → Developer → Clear Network Activity
2. Disable WiFi, enable cellular with known data monitoring
3. Use app for typical session (launch, check-in, subscribe)
4. Check data usage in Settings or use Charles Proxy
5. Repeat on WiFi for comparison

### Network Activity Breakdown
- RevenueCat entitlement check: ~20 KB
- RevenueCat purchase flow: ~50 KB
- Analytics events (batch): ~30 KB/day
- Widget data fetch (if cloud-sync added): N/A (local only currently)

### Optimization Checklist
- [ ] Cache RevenueCat responses (24h TTL)
- [ ] Batch analytics events (daily upload)
- [ ] Use gzip compression for API calls
- [ ] Avoid downloading unnecessary assets
- [ ] Test on cellular, not just WiFi

---

## 5. Widget Performance

### Targets
| Metric | Target | Maximum | Notes |
|--------|--------|---------|-------|
| **Refresh Time** | 0.3s | 0.5s | Time to update UI |
| **Timeline Generation** | 0.5s | 1.0s | Creating 24h timeline |
| **Memory (per widget)** | 15 MB | 20 MB | Each widget instance |
| **CPU (during refresh)** | <5% | 10% | Brief spike OK |

### Measurement Method
1. Add widget to Home Screen
2. Use Xcode → Debug Navigator → Energy
3. Trigger widget refresh (change app data)
4. Measure time until widget UI updates
5. Check memory graph for widget process

### Widget Refresh Frequency
- **Default:** Every 30 minutes (system-determined)
- **After check-in:** Immediate update via `WidgetCenter.shared.reloadAllTimelines()`
- **Background App Refresh:** Not required for basic functionality

### Optimization Checklist
- [ ] Use `TimelineProvider` correctly
- [ ] Pre-compute widget data (don't fetch in `getTimeline`)
- [ ] Use `StaticConfiguration` where possible
- [ ] Minimize view complexity (SwiftUI rendering cost)
- [ ] Test with multiple widgets on screen

---

## 6. Database Performance (CoreData)

### Targets
| Operation | Target | Maximum | Notes |
|-----------|--------|---------|-------|
| **Fetch 100 Check-Ins** | 30 ms | 50 ms | Typical history view |
| **Save Check-In** | 50 ms | 100 ms | Single record insert |
| **Fetch Today's Check-Ins** | 10 ms | 25 ms | With predicate |
| **Data Migration (1000 records)** | 1.0s | 2.0s | Model version upgrade |

### Measurement Method
1. Use **Instruments → Core Data** template
2. Trigger fetch/save operations
3. Measure time in Instruments timeline
4. Repeat with 10, 100, 1000 records
5. Identify slow queries

### CoreData Best Practices
- ✅ Use batch fetching for large datasets
- ✅ Use predicates to limit results
- ✅ Index frequently-queried attributes
- ✅ Use background contexts for heavy writes
- ✅ Implement pagination for UI lists

### Optimization Checklist
- [ ] Add indexes on `timestamp` and `userId`
- [ ] Use `NSBatchDeleteRequest` for bulk deletes
- [ ] Fetch only required attributes (not entire object)
- [ ] Use `@FetchRequest` with appropriate limits
- [ ] Profile migration performance with test data

---

## 7. Watch Connectivity Sync

### Targets
| Metric | Target | Maximum | Notes |
|--------|--------|---------|-------|
| **iPhone → Watch** | 5s | 30s | Data transfer time |
| **Watch → iPhone** | 5s | 30s | Data transfer time |
| **Background Transfer** | 30s | 5 min | When app not active |
| **Sync Reliability** | 99% | 95% | Success rate |

### Measurement Method
1. Perform check-in on iPhone
2. Start timer
3. Open Watch app
4. Verify data appears
5. Stop timer
6. Repeat 10 times, log failures

### Watch Connectivity Modes
- **Interactive Messaging:** `sendMessage` (foreground, fast)
- **Background Transfer:** `transferUserInfo` (background, slower)
- **App Context:** `updateApplicationContext` (latest state, overrides)

### Optimization Checklist
- [ ] Use `updateApplicationContext` for state updates
- [ ] Use `transferUserInfo` for check-in history
- [ ] Batch transfers (don't send per check-in)
- [ ] Handle connectivity failures gracefully
- [ ] Queue transfers when Watch unreachable

---

## 8. Notification Delivery

### Targets
| Metric | Target | Maximum | Notes |
|--------|--------|---------|-------|
| **Scheduled Accuracy** | ±10s | ±30s | Time from schedule to delivery |
| **Delivery Rate** | 99% | 95% | % of notifications delivered |
| **Cold Start from Notification** | 1.0s | 1.5s | Tap notification → app open |

### Measurement Method
1. Schedule notification for +5 minutes
2. Note exact scheduled time
3. Wait for notification
4. Record actual delivery time
5. Calculate delta
6. Repeat 10 times

### iOS Notification Throttling
- **Expected:** iOS may delay notifications when:
  - Device in Low Power Mode
  - Too many notifications from app recently
  - Device under heavy load
- **Workaround:** Use Time Sensitive notifications (requires entitlement)

### Optimization Checklist
- [ ] Use `UNNotificationRequest` with exact trigger
- [ ] Request Time Sensitive notification permission (future)
- [ ] Test notification delivery in various device states
- [ ] Handle notification tap to correct screen
- [ ] Test with Do Not Disturb enabled

---

## 9. Subscription Flow Performance

### Targets
| Metric | Target | Maximum | Notes |
|--------|--------|---------|-------|
| **Payment Sheet Load** | 0.5s | 1.0s | StoreKit UI appears |
| **Purchase Completion** | 2s | 5s | From confirm → entitlement granted |
| **Restore Purchases** | 1s | 3s | From tap → Pro unlocked |
| **Entitlement Check (Cached)** | 50ms | 200ms | RevenueCat SDK |
| **Entitlement Check (Network)** | 1s | 3s | RevenueCat API call |

### Measurement Method
1. Open Upgrade screen
2. Tap Subscribe button
3. Start timer
4. Approve purchase (Sandbox)
5. Stop timer when Pro badge appears
6. Log time

### RevenueCat SDK Performance
- **Caching:** Entitlements cached for 24h
- **Network:** Only checks on first launch or cache expiry
- **Offline:** Falls back to local receipt validation

### Optimization Checklist
- [ ] Configure RevenueCat SDK caching
- [ ] Show loading indicator during purchase
- [ ] Handle purchase errors gracefully
- [ ] Test purchase flow on slow network
- [ ] Verify offline receipt validation

---

## 10. Accessibility Performance

### Targets
| Metric | Target | Notes |
|--------|--------|-------|
| **VoiceOver Response Time** | <0.5s | Time from element focus → speech |
| **Dynamic Type Render** | <0.2s | Layout update after type size change |
| **High Contrast Mode** | No FPS drop | Maintain 60 FPS |

### Measurement Method
1. Enable VoiceOver
2. Navigate app with swipe gestures
3. Note any lag or stuttering
4. Enable largest Dynamic Type
5. Verify layout adjusts smoothly

### Optimization Checklist
- [ ] Test all screens with VoiceOver enabled
- [ ] Test all Dynamic Type sizes (XS → XXXL)
- [ ] Ensure 60 FPS with accessibility features on
- [ ] Use accessibility-specific layout when needed

---

## Performance Testing Schedule

### Before Every Release
- ✅ App launch time (5 launches)
- ✅ Memory usage (full flow)
- ✅ Battery drain (10 min active use)
- ✅ Widget refresh time

### Monthly (or Major Features)
- ✅ Full CoreData performance suite
- ✅ Watch sync reliability test
- ✅ Notification delivery accuracy
- ✅ Subscription flow timing

### Quarterly
- ✅ Full battery impact study (24h)
- ✅ Network usage audit
- ✅ Accessibility performance review

---

## Performance Regression Alerts

### Red Flags (Block Release)
- ❌ App launch >2.5s on iPhone 12
- ❌ Memory usage >200 MB peak
- ❌ Battery drain >10% per hour active use
- ❌ Crash rate >1%
- ❌ Notification delivery <90%

### Yellow Flags (Investigate)
- ⚠️ App launch 2.0-2.5s
- ⚠️ Memory usage 150-200 MB
- ⚠️ Battery drain 5-10% per hour
- ⚠️ Widget refresh >1s
- ⚠️ Sync failures >10%

---

## Monitoring Tools

### Development
- Xcode Instruments (Time Profiler, Allocations, Leaks, Energy)
- Xcode Debug Navigator (CPU, Memory, Disk, Network)
- Console.app for system logs

### Production
- RevenueCat Dashboard (subscription metrics)
- Analytics (custom performance events, future)
- App Store Connect (crash reports, battery metrics)
- TestFlight feedback forms

---

## Performance Budget Summary

**Key Metrics (iPhone 12, iOS 17):**
- Launch: <2s cold, <1s warm
- Memory: <100 MB active, <50 MB idle
- Battery: <5% daily total
- Network: <250 KB daily
- Widget: <0.5s refresh

**Ship Decision:** If any red flag persists, do not ship. Fix or defer feature.

---

## Notes
- Metrics updated quarterly or after major iOS releases
- Test on both minimum spec (iPhone SE) and recommended (iPhone 12)
- Real-world performance > synthetic benchmarks
- User perception matters: "feels fast" is the goal
