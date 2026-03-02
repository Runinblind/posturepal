# Assets & Resources Checklist - PosturePal Pro

**Generated:** 2026-03-01 18:28 CST  
**Status:** All code complete, assets need creation

---

## ✅ What We Have (Complete)

### Code
- ✅ 29 Swift files (7,302 lines)
- ✅ All features implemented (Weeks 1-5)
- ✅ MVVM architecture
- ✅ Complete ViewModels, Models, Views, Services

### Documentation
- ✅ Integration guides (INTEGRATION-ROADMAP.md, etc.)
- ✅ QA test plans (complete)
- ✅ Marketing strategy (complete)
- ✅ ASO strategy (App Store listing ready)
- ✅ RevenueCat integration guide

### Dependencies (Add via Xcode)
- ✅ RevenueCat SDK (via Swift Package Manager)
- ✅ SwiftUI Charts (built into iOS 16+)
- ✅ CoreData (built-in)
- ✅ WatchConnectivity (built-in)
- ✅ WidgetKit (built-in)

---

## ⏳ What You Need to Create

### 1. App Icon (Required)
**Sizes Needed:**
- iPhone: 60x60, 120x120, 180x180 @2x/3x
- iPad: 76x76, 152x152 @2x
- App Store: 1024x1024 (no transparency)
- Watch: 48x48, 55x55, 58x58, 87x87, 172x172, 196x196

**Design Specs:**
- Main icon: Spine/back silhouette with checkmark
- Colors: Blue primary (#007AFF), white/light gray secondary
- Simple, recognizable at small sizes
- No text in icon (Apple guidelines)

**Tools:**
- Design in Figma/Sketch/Illustrator
- Export all sizes via Xcode Asset Catalog
- Or use: https://appicon.co (free icon generator)

**Priority:** HIGH (Required for Xcode build)

---

### 2. Launch Screen Assets (Required)
**What's Needed:**
- LaunchScreen.storyboard (Xcode generates default)
- App name text: "PosturePal Pro"
- Simple icon or logo
- Background color: White or light gray

**OR Use SwiftUI Launch Screen (iOS 16+):**
```swift
// LaunchScreenView.swift
struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 20) {
                Image(systemName: "figure.stand")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                Text("PosturePal Pro")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
        }
    }
}
```

**Priority:** MEDIUM (Default works, custom is nicer)

---

### 3. Notification Sounds (Optional)
**Current Status:**
- Code references 8 sounds: gentle, chime, bell, ding, swoosh, ping, tone, alert, silent
- Uses system sounds if not provided

**To Add Custom Sounds:**
1. Create 8 audio files (.caf or .wav format)
2. Each 1-3 seconds long
3. Add to Xcode project bundle
4. Reference in code: `UNNotificationSound(named: "gentle.caf")`

**Free Sound Resources:**
- https://freesound.org
- https://mixkit.co/free-sound-effects
- https://zapsplat.com

**Priority:** LOW (System sounds work fine, custom is polish)

---

### 4. Screenshot Assets (For App Store)
**Needed:** 10 screenshots per device size

**iPhone 6.7" (iPhone 15 Pro Max):**
- 1290 x 2796 pixels
- 10 screenshots showing features

**iPhone 6.5" (iPhone 14 Plus):**
- 1284 x 2778 pixels  
- Can reuse 6.7" with slight crop

**iPad Pro 12.9":**
- 2048 x 2732 pixels
- Optional (if supporting iPad)

**Apple Watch:**
- 396 x 484 pixels (Series 9)
- 5 screenshots

**Strategy:** (From LAUNCHER agent)
1. Main Dashboard (streak count)
2. Apple Watch feature
3. Achievement badges
4. Analytics charts
5. Settings customization
6. Widget showcase
7. Onboarding flow
8. Pro features comparison
9. Testimonials/benefits
10. Call-to-action

**Tools:**
- Take screenshots in Xcode simulator (Cmd+S)
- Use: https://app-mockup.com or https://previewed.app
- Add captions/overlays in Figma/Photoshop

**Priority:** MEDIUM (Needed for App Store submission)

---

### 5. App Store Assets (For Listing)
**App Preview Video (Optional but Recommended):**
- 30-second video
- Script ready in APP-STORE-LISTING-FINAL.md
- Screen recording of app + voiceover
- Tools: QuickTime screen recording + iMovie/Final Cut

**Privacy Policy (Required):**
- Create privacy policy page
- Must cover: Data collection, RevenueCat, HealthKit (if used)
- Host at: yourwebsite.com/privacy
- Add URL to Xcode Info.plist

**Support URL (Required):**
- Create support page or email
- support@posturepal.app or your domain
- Add to Xcode Info.plist

**Terms of Service (Required for Subscriptions):**
- Standard subscription terms
- Host at: yourwebsite.com/terms
- Add URL to Xcode Info.plist

**Priority:** HIGH (Required for App Store submission)

---

### 6. Color Assets (Xcode Asset Catalog)
**Create in Xcode:**

**Colors.xcassets:**
```
Primary Blue: #007AFF (iOS default blue)
Secondary Gray: #8E8E93
Background: #FFFFFF (light) / #000000 (dark)
Success Green: #34C759
Warning Yellow: #FFCC00
Error Red: #FF3B30
```

**Dynamic Colors (Light/Dark Mode):**
- Background: White (light) / Black (dark)
- Text: Black (light) / White (dark)
- Secondary: Gray (light) / Light Gray (dark)

**How to Create:**
1. Xcode → Assets.xcassets
2. + → New Color Set
3. Set light/dark variants
4. Reference in code: `Color("PrimaryBlue")`

**Priority:** MEDIUM (Can use system colors initially)

---

### 7. Image Assets (Optional)
**Achievement Badges:**
- Currently using SF Symbols (built-in)
- Optional: Create custom badge designs
- 14 achievement icons needed

**Onboarding Illustrations:**
- Currently text-based
- Optional: Add illustrations for better UX
- 5 onboarding screens

**Analytics Charts:**
- Using SwiftUI Charts (built-in)
- No custom images needed

**Priority:** LOW (SF Symbols work great)

---

## 📋 Priority Action Plan

### Phase 1: Essential (Must-Have for Xcode Build)
1. ✅ **App Icon** - Create 1024x1024, generate all sizes
2. ✅ **Launch Screen** - Use default or create simple SwiftUI view
3. ✅ **Color Assets** - Define in Xcode (or use system colors)

**Time:** 1-2 hours (or 15 min with app icon generator)

---

### Phase 2: App Store Submission (Must-Have for Release)
1. ✅ **Privacy Policy** - Write and host
2. ✅ **Terms of Service** - Write and host
3. ✅ **Support URL** - Create page or use email
4. ✅ **Screenshots** - Take 10 from simulator, add captions
5. ⏳ **App Preview Video** - Optional but recommended

**Time:** 3-4 hours

---

### Phase 3: Polish (Nice-to-Have)
1. ⏳ **Custom Notification Sounds** - 8 audio files
2. ⏳ **Custom Achievement Icons** - 14 badge designs
3. ⏳ **Onboarding Illustrations** - 5 custom images

**Time:** 5-10 hours (designer work)

---

## 🎨 Quick Asset Creation Guide

### Option 1: DIY (Free)
**App Icon:**
1. Design 1024x1024 in Figma (free)
2. Use: https://appicon.co to generate all sizes
3. Import to Xcode Assets.xcassets

**Screenshots:**
1. Run app in Xcode simulator (iPhone 15 Pro Max)
2. Cmd+S to capture screenshots
3. Use: https://previewed.app to add device frames
4. Add text overlays in Canva (free)

**Privacy Policy:**
1. Use generator: https://www.privacypolicygenerator.info
2. Customize for your app
3. Host on GitHub Pages (free) or your domain

**Time:** 2-3 hours total

---

### Option 2: Outsource (Paid)
**Fiverr/Upwork:**
- App icon design: $20-100
- 10 screenshots with captions: $30-80
- App preview video: $50-200
- Privacy policy: $20-50

**Total:** $120-430 for professional assets

**Time:** 1-2 days turnaround

---

### Option 3: AI Tools (Fast & Cheap)
**App Icon:**
- Midjourney/DALL-E: Generate spine/posture icon
- Cleanup in Figma
- Generate sizes with appicon.co

**Screenshots:**
- Use real app screenshots
- AI upscale/enhance with Topaz or similar
- Add captions with Canva

**Privacy Policy:**
- ChatGPT/Claude: "Generate iOS app privacy policy for [features]"
- Customize and host

**Time:** 1-2 hours total  
**Cost:** Minimal (AI subscription if you have one)

---

## 🚀 Recommended Workflow

### Today (Before Starting Xcode Integration)
1. **Generate app icon** (15 min)
   - Use appicon.co or Figma template
   - Get 1024x1024 + all sizes

2. **Write privacy policy** (30 min)
   - Use template generator
   - Cover: Notifications, RevenueCat, HealthKit
   - Host on GitHub Pages or your site

3. **Define color assets** (10 min)
   - Document hex codes (or use system colors)
   - Will add to Xcode during integration

**Total:** 1 hour prep

---

### During Xcode Integration (Phase 1-2)
1. Import app icon to Assets.xcassets
2. Create LaunchScreen (or use default)
3. Add color assets
4. Add Info.plist URLs (privacy, support, terms)

---

### Before App Store Submission (Phase 4)
1. Take screenshots from physical device
2. Add device frames + captions
3. Create app preview video (optional)
4. Prepare App Store listing copy (already done!)

---

## 📂 Where to Put Assets

### In Xcode Project
```
PosturePal Pro/
├── Assets.xcassets/
│   ├── AppIcon.appiconset/
│   │   └── [all icon sizes]
│   ├── Colors/
│   │   ├── PrimaryBlue.colorset
│   │   ├── Background.colorset
│   │   └── ...
│   └── Images/ (optional)
│       └── [custom images]
├── Sounds/ (optional)
│   ├── gentle.caf
│   ├── chime.caf
│   └── ...
└── Info.plist
    ├── Privacy Policy URL
    ├── Support URL
    └── Terms URL
```

### For App Store (External)
```
App Store Assets/
├── Screenshots/
│   ├── iPhone-6.7/
│   │   ├── screenshot-1.png (1290x2796)
│   │   ├── screenshot-2.png
│   │   └── ... (10 total)
│   └── Watch/
│       ├── screenshot-1.png (396x484)
│       └── ... (5 total)
├── App-Preview-Video/
│   └── preview.mp4 (30 sec, up to 500MB)
└── Website/
    ├── privacy-policy.html
    ├── terms-of-service.html
    └── support.html
```

---

## ✅ Checklist

### Essential (Do Before Integration)
- [ ] App icon (1024x1024 + all sizes)
- [ ] Privacy policy written & hosted
- [ ] Terms of service written & hosted
- [ ] Support email or page created

### Integration Phase
- [ ] Import app icon to Xcode
- [ ] Create/customize launch screen
- [ ] Add color assets
- [ ] Add Info.plist URLs

### Pre-Submission Phase
- [ ] 10 iPhone screenshots captured
- [ ] 5 Watch screenshots captured
- [ ] Device frames & captions added
- [ ] App preview video (optional)

### Nice-to-Have
- [ ] Custom notification sounds (8 files)
- [ ] Custom achievement icons (14 images)
- [ ] Onboarding illustrations (5 images)

---

## 🆘 If You Get Stuck

**App Icon Issues:**
- Xcode requires all sizes filled
- Use appicon.co to generate from 1024x1024
- Or use placeholder (SF Symbol) during dev

**Privacy Policy Help:**
- Must have one for App Store
- Use generator + customize
- RevenueCat template: https://www.revenuecat.com/privacy-policy-template

**Screenshot Tips:**
- Simulator: Cmd+S captures screenshot
- Physical device: Volume Up + Side button
- Add frames: https://previewed.app or https://shotsnapp.com

**Hosting Free:**
- GitHub Pages (free static hosting)
- Netlify (free tier)
- Vercel (free tier)

---

## 📊 Time & Cost Estimate

### DIY Approach
- **Time:** 3-4 hours total
- **Cost:** $0 (using free tools)
- **Quality:** Good for MVP/testing

### Hybrid Approach
- **Time:** 2 hours + 1-2 days wait
- **Cost:** $50-150 (outsource icon + screenshots)
- **Quality:** Professional

### Full Professional
- **Time:** 1 hour + 3-5 days wait
- **Cost:** $300-500 (designer + video)
- **Quality:** App Store featured-level

---

## 🎯 Recommended: Start Simple

**For initial TestFlight:**
1. ✅ Simple app icon (15 min with generator)
2. ✅ Default launch screen
3. ✅ Basic privacy policy (30 min)
4. ✅ System colors

**Polish later for App Store:**
1. Professional screenshots
2. App preview video
3. Custom icons/sounds
4. Refined branding

**Philosophy:** Ship MVP fast, iterate based on feedback.

---

**Status:** All code ready, assets are final 10% of polish. Start with essentials, polish later.

**Location:** Save asset files to `projects/posture-app/assets/` when created.
