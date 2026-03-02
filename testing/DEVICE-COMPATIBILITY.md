# Device Compatibility Guide

## Overview
PosturePal Pro targets a wide range of iOS and watchOS devices while maintaining optimal performance on modern hardware.

---

## Minimum Requirements

### iPhone
- **Model:** iPhone SE (2nd generation, 2020) or newer
- **OS:** iOS 16.0 or later
- **RAM:** 3 GB minimum
- **Storage:** 50 MB free space
- **Network:** WiFi or cellular (for subscription only)

### Apple Watch
- **Model:** Apple Watch Series 5 or newer
- **OS:** watchOS 9.0 or later
- **Paired iPhone required**

### iPad (Future Support)
- **Model:** iPad (9th generation) or newer, iPad Air 3+, iPad Pro
- **OS:** iPadOS 16.0 or later
- **Status:** Currently phone-only UI, iPad optimization planned

---

## Recommended Specifications

### Optimal Experience
- **iPhone:** iPhone 12 or newer
- **OS:** iOS 17.0 or later
- **Watch:** Apple Watch Series 6 or newer
- **OS:** watchOS 10.0 or later

**Why?**
- Better Dynamic Island integration (iPhone 14 Pro+)
- Improved widget interactivity (iOS 17)
- Enhanced Watch complications (watchOS 10)
- Faster app launch and sync
- Lower battery drain

---

## Device-Specific Features

### iPhone Models

#### iPhone SE (2020-2024)
- ✅ Full feature support
- ✅ All widgets available
- ⚠️ Smaller screen: UI may feel cramped
- ⚠️ Older chip: slightly slower animations
- **Status:** Fully supported, primary test device for minimum spec

#### iPhone 11 / XR / XS
- ✅ Full feature support
- ✅ All widgets available
- ✅ Great performance
- **Status:** Fully supported

#### iPhone 12 / 13
- ✅ Full feature support
- ✅ All widgets available
- ✅ Excellent performance
- ✅ MagSafe charging compatible
- **Status:** Recommended, primary test device

#### iPhone 14
- ✅ Full feature support
- ✅ All widgets available
- ✅ Excellent performance
- **iPhone 14 Pro/Pro Max only:**
  - ✅ Dynamic Island notification integration (future)
  - ✅ Always-On Display widget visibility

#### iPhone 15 / 15 Pro
- ✅ Full feature support
- ✅ All widgets available
- ✅ Best performance
- ✅ USB-C charging
- **iPhone 15 Pro/Pro Max only:**
  - ✅ Action Button integration (future)
  - ✅ Dynamic Island optimization

---

### Apple Watch Models

#### Apple Watch Series 5
- ✅ Basic watch app support
- ✅ Complications (limited families)
- ⚠️ Smaller screen (40mm/44mm)
- ⚠️ Slower sync due to older chip
- **Status:** Minimum supported device

#### Apple Watch Series 6 / SE (1st gen)
- ✅ Full watch app support
- ✅ All complication families
- ✅ Good performance
- ✅ Blood oxygen sensor (S6 only, not used yet)
- **Status:** Recommended minimum

#### Apple Watch Series 7
- ✅ Full watch app support
- ✅ Larger screen (41mm/45mm)
- ✅ Faster charging
- ✅ Better tap targets due to size

#### Apple Watch Series 8 / SE (2nd gen)
- ✅ Full watch app support
- ✅ Excellent performance
- ✅ Crash detection (S8 only, not used)

#### Apple Watch Series 9
- ✅ Full watch app support
- ✅ Best performance
- ✅ Double-tap gesture (future integration)
- ✅ On-device Siri processing

#### Apple Watch Ultra / Ultra 2
- ✅ Full watch app support
- ✅ Extra-large screen (49mm)
- ✅ Additional complication slots
- ✅ Best battery life
- ✅ Action Button integration (future)

---

## iPad Support

### Current Status
- ⚠️ **Not optimized:** Runs iPhone app in compatibility mode
- ✅ **Functional:** All features work, UI is scaled up
- 📋 **Planned:** Native iPad UI in version 2.0

### Tested iPads
- iPad (9th gen): Works, but UI not optimized
- iPad Air (4th/5th gen): Works well, large canvas
- iPad Pro (11"/12.9"): Works perfectly, but underutilized

### Future iPad Features (Roadmap)
- Multi-column layout
- Landscape optimization
- Keyboard shortcuts
- Drag & drop support

---

## OS Version Support

### iOS
- **Minimum:** iOS 16.0 (required for widget interactivity baseline)
- **Target:** iOS 17.0+ (recommended for best experience)
- **Tested:** iOS 16.0, 16.4, 17.0, 17.2, 17.4, 18.0 beta

### watchOS
- **Minimum:** watchOS 9.0 (required for modern SwiftUI features)
- **Target:** watchOS 10.0+ (recommended for redesigned UI)
- **Tested:** watchOS 9.0, 9.4, 10.0, 10.2

### Future Deprecation Policy
- **1 year after new iOS release:** Drop support for iOS-2
- **Example:** When iOS 18 ships, drop iOS 16 support within 1 year
- **Watch follows iOS policy**

---

## Feature Availability by OS Version

| Feature | iOS 16 | iOS 17+ | watchOS 9 | watchOS 10+ |
|---------|--------|---------|-----------|-------------|
| Core reminders | ✅ | ✅ | ✅ | ✅ |
| Check-ins | ✅ | ✅ | ✅ | ✅ |
| Widgets | ✅ Basic | ✅ Interactive | ✅ | ✅ Enhanced |
| Lock Screen widgets | ✅ | ✅ | ❌ | ❌ |
| Watch app | ✅ | ✅ | ✅ | ✅ |
| Watch complications | ✅ Limited | ✅ Limited | ✅ | ✅ All families |
| Live Activities | ❌ | ✅ (future) | ❌ | ❌ |
| StandBy mode | ❌ | ✅ (auto) | ❌ | ❌ |
| App Intents | ❌ | ✅ Shortcuts | ❌ | ✅ Shortcuts |

---

## Performance Expectations

### App Launch Time
| Device | Cold Launch | Warm Launch |
|--------|-------------|-------------|
| iPhone SE (2020) | ~2.0s | ~0.8s |
| iPhone 12 | ~1.5s | ~0.6s |
| iPhone 14 Pro | ~1.2s | ~0.4s |
| iPhone 15 Pro | ~1.0s | ~0.3s |

### Memory Usage
| Device | Idle | Active | Peak |
|--------|------|--------|------|
| iPhone SE | 45 MB | 80 MB | 120 MB |
| iPhone 12+ | 50 MB | 90 MB | 140 MB |

### Battery Impact (24h period, typical use)
| Device | Background | Active (10 min/day) | Total |
|--------|-----------|---------------------|-------|
| iPhone SE | 1-2% | 2-3% | 3-5% |
| iPhone 12+ | <1% | 1-2% | 2-4% |
| Watch S5 | 2-3% | 3-4% | 5-7% |
| Watch S6+ | 1-2% | 2-3% | 3-5% |

---

## Testing Device Matrix

### Primary Test Devices (Must Test Every Release)
1. **iPhone SE (2020), iOS 16.0** - Minimum spec baseline
2. **iPhone 13, iOS 17.2** - Mid-range, most common
3. **iPhone 15 Pro, iOS 17.4** - Latest flagship
4. **Apple Watch S6, watchOS 10.0** - Watch baseline
5. **Apple Watch S8, watchOS 10.2** - Current Watch

### Secondary Test Devices (Test Major Releases)
6. iPad (9th gen), iPadOS 17
7. iPhone 11, iOS 16.4
8. Apple Watch SE 2, watchOS 10

### Beta Testing Devices (Optional, Community)
9. iPhone 14 Pro (Dynamic Island testing)
10. Apple Watch Ultra (large screen edge cases)

---

## Known Device-Specific Issues

### iPhone SE (2020)
- **Issue:** Widget text slightly cramped on small widget
- **Workaround:** Use medium or large widget
- **Status:** Design tweak planned for v1.3

### Apple Watch Series 5
- **Issue:** Sync sometimes delayed (30s+)
- **Root Cause:** Older Bluetooth/WiFi chip
- **Workaround:** Ensure Watch on charger for faster sync
- **Status:** Investigating optimization

### iPad (All Models)
- **Issue:** UI not optimized, lots of white space
- **Status:** Native iPad UI in v2.0 roadmap

---

## App Store Listing Device Support

**Supported Devices (as listed in App Store Connect):**
- iPhone SE (2nd generation and later)
- iPhone 11, 11 Pro, 11 Pro Max
- iPhone 12, 12 mini, 12 Pro, 12 Pro Max
- iPhone 13, 13 mini, 13 Pro, 13 Pro Max
- iPhone 14, 14 Plus, 14 Pro, 14 Pro Max
- iPhone 15, 15 Plus, 15 Pro, 15 Pro Max
- Apple Watch Series 5, 6, 7, 8, 9
- Apple Watch SE (1st & 2nd generation)
- Apple Watch Ultra, Ultra 2

**Requires:**
- iOS 16.0 or later
- watchOS 9.0 or later (for Watch app)

---

## Accessibility Device Considerations

### VoiceOver
- ✅ Fully tested on all supported iPhones
- ✅ Watch app VoiceOver compatible

### Larger Text (Dynamic Type)
- ✅ Tested up to XXXL on iPhone SE (tightest constraint)
- ✅ No clipping or overflow issues

### High Contrast / Reduce Transparency
- ✅ Tested on iPhone 12 and SE
- ✅ All UI elements visible

### Switch Control
- ✅ All interactive elements accessible
- ✅ Tested on iPhone 13

---

## Recommendations for Users

### Best Overall Experience
- **iPhone 12 or newer** + **Apple Watch Series 6 or newer**
- **iOS 17+** and **watchOS 10+**

### Budget-Friendly Option
- **iPhone SE (2020 or newer)** + **Apple Watch SE**
- **iOS 16+** and **watchOS 9+**
- Expect slightly slower performance, but all features work

### Without Apple Watch
- **Any supported iPhone**
- App fully functional without Watch
- Watch features optional, not required

---

## Future Device Support Plans

### iOS 18 / watchOS 11 (2024)
- Add support on launch day
- Leverage new APIs (TBD)
- Continue supporting iOS 16 for 6-12 months

### Vision Pro (Future)
- Not currently supported
- Evaluating viability for posture tracking in visionOS
- Possible integration with spatial computing features

### Android (Not Planned)
- No current plans for Android version
- Focus remains on iOS/watchOS ecosystem

---

## Testing Resources

### TestFlight Beta Distribution
- Supports all devices listed above
- Testers must have compatible device
- Beta builds expire after 90 days

### Physical Test Devices (Internal)
- iPhone SE (2020)
- iPhone 13
- iPhone 15 Pro
- Apple Watch S6
- Apple Watch S8

---

## Notes
- This document updated with each major release
- Device support may be dropped with 12-month notice
- Community feedback influences device priority
