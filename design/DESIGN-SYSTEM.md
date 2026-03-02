# DESIGN SYSTEM - Posture Reminder App

**Project:** PosturePal Pro  
**Platform:** iOS (iPhone + Apple Watch)  
**Design Language:** Calm, minimal, health-focused  
**Created:** 2026-02-28  
**Version:** 1.0

---

## Design Philosophy

**Core Principles:**
1. **Calm Over Cluttered** - This app helps reduce stress, not add to it
2. **Actionable Over Informative** - Every screen should have a clear action
3. **Motivating Over Clinical** - Health can be beautiful and encouraging
4. **Simple Over Feature-Rich** - Do one thing exceptionally well

**Visual Tone:** Peaceful, encouraging, modern wellness aesthetic

---

## Color Palette

### Primary Colors

**Brand Primary - Serene Blue**
- `#4A90E2` - Primary blue (main actions, brand)
- `#5BA3F5` - Light blue (hover states, highlights)
- `#3A7BC8` - Dark blue (pressed states)

**Brand Secondary - Fresh Green**
- `#66D9A6` - Success green (streak celebrations, check-ins)
- `#7BE3B5` - Light green (subtle backgrounds)
- `#52C290` - Dark green (active states)

### Neutral Palette

**Light Mode**
- `#FFFFFF` - Pure white (main background)
- `#F8F9FA` - Off white (cards, secondary background)
- `#E9ECEF` - Light gray (borders, dividers)
- `#ADB5BD` - Medium gray (secondary text)
- `#495057` - Dark gray (primary text)
- `#212529` - Almost black (headings)

**Dark Mode**
- `#000000` - Pure black (main background)
- `#1C1C1E` - Dark card (elevated surfaces)
- `#2C2C2E` - Lighter dark (borders, dividers)
- `#8E8E93` - Medium gray (secondary text)
- `#E5E5E7` - Light gray (primary text)
- `#FFFFFF` - Pure white (headings)

### Semantic Colors

**Success**
- `#66D9A6` - Streak achieved, check-in completed

**Warning**
- `#FFB84D` - Reminder notifications, gentle nudges

**Error/Alert**
- `#FF6B6B` - Streak broken, missed check-in (used sparingly)

**Info**
- `#4A90E2` - Tips, onboarding, educational content

### Gradients

**Brand Gradient** (for celebrations, special moments)
```
linear-gradient(135deg, #4A90E2 0%, #66D9A6 100%)
```

**Subtle Background** (for cards, sections)
```
linear-gradient(180deg, #F8F9FA 0%, #FFFFFF 100%)
```

**Dark Mode Celebration**
```
linear-gradient(135deg, #3A7BC8 0%, #52C290 100%)
```

---

## Typography

### Font Family

**Primary:** SF Pro (iOS system font)
- **Reason:** Native iOS feel, optimized readability, accessibility support
- **Fallback:** System default

**Display/Marketing:** SF Pro Rounded (for streak numbers, celebrations)
- **Reason:** Friendly, approachable for large numbers

### Type Scale

**Display (Streak Counter)**
- Font: SF Pro Rounded Bold
- Size: 72pt / 5.0rem
- Line Height: 1.0
- Letter Spacing: -2%
- Usage: Main streak number on dashboard

**Heading 1**
- Font: SF Pro Bold
- Size: 34pt / 2.125rem
- Line Height: 1.2
- Letter Spacing: -1%
- Usage: Screen titles, major sections

**Heading 2**
- Font: SF Pro Semibold
- Size: 28pt / 1.75rem
- Line Height: 1.3
- Letter Spacing: -0.5%
- Usage: Section headers

**Heading 3**
- Font: SF Pro Semibold
- Size: 22pt / 1.375rem
- Line Height: 1.4
- Letter Spacing: 0%
- Usage: Card titles

**Body Large**
- Font: SF Pro Regular
- Size: 17pt / 1.0625rem
- Line Height: 1.5
- Letter Spacing: 0%
- Usage: Primary body text, button labels

**Body Regular**
- Font: SF Pro Regular
- Size: 15pt / 0.9375rem
- Line Height: 1.5
- Letter Spacing: 0%
- Usage: Secondary text, descriptions

**Caption**
- Font: SF Pro Regular
- Size: 13pt / 0.8125rem
- Line Height: 1.4
- Letter Spacing: 0%
- Color: Medium gray
- Usage: Timestamps, helper text

**Small**
- Font: SF Pro Regular
- Size: 11pt / 0.6875rem
- Line Height: 1.3
- Letter Spacing: 0%
- Usage: Legal text, footnotes

### Text Styles

**Emphasis:** SF Pro Semibold (not italic - cleaner look)
**Strong:** SF Pro Bold
**Links:** Underline on hover only, primary blue color

---

## Spacing System

**Base Unit:** 4pt

**Spacing Scale:**
- `4pt` (0.25rem) - Tight spacing within components
- `8pt` (0.5rem) - Related elements
- `12pt` (0.75rem) - Small gaps
- `16pt` (1rem) - Default spacing between components
- `24pt` (1.5rem) - Section spacing
- `32pt` (2rem) - Large gaps between major sections
- `48pt` (3rem) - Screen padding (top/bottom)
- `64pt` (4rem) - Extra large spacing

**Layout Margins:**
- iPhone: 20pt side margins
- iPad: 32pt side margins
- Apple Watch: 12pt side margins

**Safe Areas:** Always respect iOS safe area insets (top notch, bottom home indicator)

---

## Components

### Buttons

**Primary Button**
- Background: `#4A90E2`
- Text: White, SF Pro Semibold, 17pt
- Padding: 16pt vertical, 24pt horizontal
- Border Radius: 12pt
- Height: 50pt minimum (touch target)
- Shadow: `0px 2px 8px rgba(74, 144, 226, 0.2)`
- Hover: `#5BA3F5`
- Pressed: `#3A7BC8`
- Disabled: `#E9ECEF`, text `#ADB5BD`

**Secondary Button**
- Background: `#F8F9FA`
- Text: `#4A90E2`, SF Pro Semibold, 17pt
- Border: 1pt solid `#E9ECEF`
- Padding: 16pt vertical, 24pt horizontal
- Border Radius: 12pt
- Height: 50pt minimum
- Hover: `#E9ECEF`

**Text Button**
- Background: Transparent
- Text: `#4A90E2`, SF Pro Regular, 17pt
- Padding: 12pt vertical, 16pt horizontal
- Underline on press

**Icon Button (Apple Watch)**
- Circle, 44pt diameter
- Background: `#1C1C1E` (dark) or `#F8F9FA` (light)
- Icon: 24pt SF Symbols
- Haptic feedback on tap

### Cards

**Default Card**
- Background: `#FFFFFF` (light) / `#1C1C1E` (dark)
- Border Radius: 16pt
- Padding: 20pt
- Shadow: `0px 2px 12px rgba(0, 0, 0, 0.06)` (light mode only)
- Border (dark mode): 1pt solid `#2C2C2E`

**Streak Card (Dashboard)**
- Background: Brand gradient
- Border Radius: 20pt
- Padding: 32pt
- Text: White
- Shadow: `0px 4px 16px rgba(74, 144, 226, 0.15)`

**Setting Card**
- Background: `#F8F9FA` (light) / `#1C1C1E` (dark)
- Border Radius: 12pt
- Padding: 16pt
- Tap feedback: Scale 0.98 on press

### Streak Counter

**Main Counter (Dashboard)**
- Container: Streak Card (gradient background)
- Number: 72pt SF Pro Rounded Bold, white
- Label: "day streak" - 17pt SF Pro Regular, white opacity 80%
- Icon: 🔥 emoji (48pt) above number
- Animation: Pulse on new check-in, confetti on milestones (7, 30, 100 days)

**Small Counter (Widget, Watch)**
- Number: 34pt SF Pro Rounded Bold
- Label: "days" - 13pt SF Pro Regular
- Compact layout

### Toggle Switch

- Use iOS native `UISwitch`
- On Color: `#66D9A6` (success green)
- Off Color: `#E9ECEF`
- Size: Standard iOS (51 x 31pt)

### Slider (Interval Picker)

- Track: 4pt height
- Active: `#4A90E2`
- Inactive: `#E9ECEF`
- Thumb: 28pt circle, white with shadow
- Labels: Caption text below slider at min/max/current value

### Notification Badge

- Background: `#FF6B6B` (alert red)
- Text: White, SF Pro Bold, 11pt
- Border Radius: Full circle
- Minimum: 18pt diameter
- Padding: 4pt horizontal (for 2+ digits)

### Progress Ring (Watch Complication)

- Track: `#2C2C2E` (3pt stroke)
- Progress: `#66D9A6` (4pt stroke)
- Center: Streak number (SF Pro Rounded Bold)
- Animation: Smooth fill on check-in

---

## Icons & Imagery

### App Icon

**Concept:** Modern, minimal back/spine icon with health aesthetic

**Design:**
- **Base:** Rounded square (iOS standard)
- **Background:** Brand gradient (`#4A90E2` to `#66D9A6`)
- **Icon:** White silhouette of upright spine/back (front view)
  - Simple geometric curves (3 curves: neck, thoracic, lumbar)
  - Centered vertically
  - 60% of icon height
- **Style:** Flat, no shadows, no text
- **Export:** All required iOS sizes (20pt to 1024pt)

**Alternative Concept (if spine too clinical):**
- Stylized person sitting with good posture (side view)
- Or abstract "check mark + spine" fusion

### SF Symbols Usage

Use iOS SF Symbols for all interface icons:

**Common Icons:**
- `bell.fill` - Notifications
- `gear` - Settings
- `flame.fill` - Streak (with color override `#FFB84D`)
- `calendar` - Schedule/History
- `moon.fill` - Quiet hours
- `applewatch` - Watch settings
- `hand.raised.fill` - Check-in action
- `chart.bar.fill` - Statistics
- `star.fill` - Milestones
- `checkmark.circle.fill` - Completed check-in

**Style:** Use `.fill` variants for primary actions, outline for secondary

### Illustrations (Onboarding)

**Style:** Minimal line art, brand colors, friendly

**Screen 1 - Problem**
- Illustration: Person hunched at desk (side view), dotted line showing poor posture curve
- Color: `#FF6B6B` for bad posture line

**Screen 2 - Solution**
- Illustration: Phone with notification + person straightening up
- Color: `#4A90E2` for notification, `#66D9A6` for good posture

**Screen 3 - Motivation**
- Illustration: Streak flame with confetti
- Color: Brand gradient, `#FFB84D` for flame

**Format:** SVG or PDF (vector), 300pt width, centered

---

## Screen Designs

### 1. Onboarding Flow (3 Screens)

**Screen 1: Welcome**

**Layout:**
```
┌─────────────────────┐
│   [Illustration]     │ (1/3 screen height)
│                      │
│   Stay Pain-Free     │ (H1, centered)
│                      │
│ Gentle reminders to  │ (Body, centered, gray)
│  check your posture  │
│   throughout the     │
│        day           │
│                      │
│                      │
│  [Continue Button]   │ (Primary, full width - 20pt margins)
│                      │
│      • • •           │ (Page indicators, centered)
└─────────────────────┘
```

**Screen 2: How It Works**

```
┌─────────────────────┐
│   [Illustration]     │
│                      │
│   Simple Reminders   │
│                      │
│ We'll send you a     │
│ gentle notification  │
│ every hour. Just     │
│ tap to check in.     │
│                      │
│                      │
│  [Continue Button]   │
│                      │
│      • • •           │
└─────────────────────┘
```

**Screen 3: Build Your Streak**

```
┌─────────────────────┐
│   [Illustration]     │
│                      │
│   Build Your Habit   │
│                      │
│ Track your progress  │
│ and build a daily    │
│ streak. Your back    │
│ will thank you! 🙏   │
│                      │
│                      │
│  [Get Started]       │ (Primary)
│                      │
│      • • •           │
└─────────────────────┘
```

**Interactions:**
- Swipe between screens
- Auto-advance page indicators
- Skip button (top right, text button) on screens 1-2
- Haptic feedback on page change

---

### 2. Main Dashboard

**Layout:**
```
┌────────────────────────────┐
│  PosturePal     [⚙️ Settings] │ (Nav bar)
├────────────────────────────┤
│                             │
│   ┌─────────────────────┐  │
│   │       🔥             │  │ (Streak card, gradient bg)
│   │                      │  │
│   │        42            │  │ (Display size number)
│   │     day streak       │  │ (Caption)
│   │                      │  │
│   │  Last: Today 2:30 PM │  │ (Small, white 80%)
│   └─────────────────────┘  │
│                             │
│   Today's Status            │ (H3)
│                             │
│   ┌──────────────────────┐ │
│   │ ✅ 9:00 AM           │ │ (Check-in card)
│   │ ✅ 11:30 AM          │ │
│   │ ✅ 2:30 PM           │ │
│   │ ⏱️  4:30 PM (due)    │ │ (Next reminder, blue)
│   └──────────────────────┘ │
│                             │
│  [✋ Check My Posture Now]  │ (Primary button)
│                             │
│   Quick Stats               │ (H3)
│   This Week: 34/42 ✓        │ (Body, green checkmark)
│   This Month: 89% 📊        │
│                             │
└────────────────────────────┘
```

**Interactions:**
- Pull to refresh (updates stats)
- Tap streak card → History view
- Tap "Check My Posture Now" → Immediate check-in (animation + haptic)
- Swipe down on check-in history item → Delete (with undo toast)

**Animations:**
- Streak number animates up when incremented
- Check-in added with slide-in from right
- Confetti overlay on milestone (7, 14, 30, 50, 100 days)

---

### 3. Settings Screen

**Layout:**
```
┌────────────────────────────┐
│ ← Settings                  │ (Nav bar with back)
├────────────────────────────┤
│                             │
│  Reminders                  │ (Section header)
│  ┌──────────────────────┐  │
│  │ Interval          [>]│  │ (Tap → Interval picker)
│  │ Every 60 minutes     │  │ (Current value, gray)
│  └──────────────────────┘  │
│                             │
│  ┌──────────────────────┐  │
│  │ Quiet Hours          │  │
│  │ [🌙 Toggle Switch]   │  │ (iOS native switch)
│  └──────────────────────┘  │
│                             │
│  ┌──────────────────────┐  │ (Only if quiet hours ON)
│  │ From: 10:00 PM    [>]│  │
│  │ To: 8:00 AM       [>]│  │
│  └──────────────────────┘  │
│                             │
│  Apple Watch                │
│  ┌──────────────────────┐  │
│  │ Watch Notifications  │  │
│  │ [Toggle Switch]      │  │
│  └──────────────────────┘  │
│                             │
│  Account                    │
│  ┌──────────────────────┐  │
│  │ 🌟 Upgrade to Pro [>]│  │ (Gold star, FREE users only)
│  └──────────────────────┘  │
│                             │
│  ┌──────────────────────┐  │
│  │ Reset Streak      [>]│  │ (Red text)
│  └──────────────────────┘  │
│                             │
│  About                      │
│  Version 1.0.0              │ (Caption, centered, gray)
│  Made with ❤️ for your back │
│                             │
└────────────────────────────┘
```

**Interval Picker Modal:**
```
┌────────────────────────────┐
│  Reminder Interval          │ (H2, centered)
│                             │
│  [─────●─────────────]      │ (Slider)
│  15min       60min    90min │ (Labels)
│                             │
│     Every 60 minutes        │ (Live preview, centered, H3)
│                             │
│  [Save]              [Cancel]│ (Buttons)
└────────────────────────────┘
```

**Interactions:**
- Settings persist immediately (no save button except for picker)
- Toggle switches use iOS native behavior
- Reset Streak → Confirmation alert ("Are you sure? This cannot be undone.")

---

### 4. Apple Watch App

**Main Face (Complication)**

**Layout:**
```
┌─────────────┐
│             │
│     🔥      │ (Emoji, centered)
│             │
│     42      │ (Streak number, SF Pro Rounded Bold 28pt)
│    days     │ (Caption, 11pt)
│             │
│  [✋ Check] │ (Button, full width)
│             │
│  Next: 45m  │ (Caption, gray, centered)
│             │
└─────────────┘
```

**Check-In Success:**
```
┌─────────────┐
│             │
│      ✅     │ (Large checkmark, animated)
│             │
│  Nice work! │ (H3, centered)
│             │
│   Streak:   │ (Caption)
│     43      │ (Number increased)
│             │
└─────────────┘
```
(Auto-dismiss after 2 seconds)

**Complications:**
- **Circular:** Progress ring (today's check-ins / expected)
- **Rectangular:** "42 day streak 🔥"
- **Corner:** Just streak number

**Interactions:**
- Tap complication → Open app
- Tap "Check" button → Haptic feedback + success animation
- Force touch → Quick settings (interval adjustment)

---

### 5. Home Screen Widget

**Small Widget (2x2)**
```
┌──────────────┐
│      🔥      │ (Centered)
│      42      │ (Bold, 34pt)
│   day streak │ (Caption)
│              │
│ Next: 1h 23m │ (Gray, small)
└──────────────┘
```

**Medium Widget (4x2)**
```
┌─────────────────────────────┐
│  🔥 42 day streak            │
│                              │
│  Today: ✅ ✅ ✅ ⏱️         │ (Visual check-in dots)
│                              │
│  Next reminder: 4:30 PM      │
└─────────────────────────────┘
```

**Large Widget (4x4)**
```
┌─────────────────────────────┐
│  🔥 42 day streak            │
│                              │
│  Today (4/5 check-ins)       │
│  ✅ 9:00  ✅ 11:30           │
│  ✅ 2:30  ⏱️ 4:30           │
│                              │
│  This Week: 34/42 ✓          │
│  ▓▓▓▓▓▓▓▓▓░ 81%             │ (Progress bar)
│                              │
│  Next reminder: 4:30 PM      │
└─────────────────────────────┘
```

**Interactions:**
- Tap widget → Open app to dashboard
- Auto-updates every 15 minutes (iOS limitation)

---

## App Store Assets

### App Store Icon (1024x1024)

Same as app icon design (spine/back silhouette on gradient), exported at high resolution.

---

### Screenshots (6.5" iPhone - 5 required)

**Screenshot 1: Hero/Dashboard**
- Show main dashboard with impressive streak (42 days)
- Status: "PAID VERSION" badge top right (shows Pro features)
- Caption overlay: "Build healthy posture habits"

**Screenshot 2: Streak Celebration**
- Dashboard showing 30-day milestone with confetti animation
- Caption: "Celebrate your progress"

**Screenshot 3: Apple Watch**
- Split screen: iPhone + Apple Watch showing synchronized check-in
- Caption: "Works seamlessly with Apple Watch"

**Screenshot 4: Smart Scheduling**
- Settings screen highlighting quiet hours and custom intervals
- Caption: "Smart reminders that fit your schedule"

**Screenshot 5: Progress Tracking**
- Stats/history view showing weekly consistency
- Caption: "Track your journey to better posture"

**Style:**
- Clean device frames (use Apple's official templates)
- Real UI screenshots (no mockups)
- Light gradient background (brand colors)
- Bold caption text overlay (SF Pro Bold, 48pt, white with shadow)

---

### App Store Preview Video (30 seconds)

**Script:**
1. (0-5s) Show person at desk with notification → straightens up
2. (5-10s) Dashboard with streak counter animating up
3. (10-15s) Apple Watch haptic notification → quick check-in
4. (15-20s) Settings showing custom interval slider
5. (20-25s) 30-day milestone celebration with confetti
6. (25-30s) End card: "PosturePal Pro - Your back will thank you" + Download button

**Style:** Clean screen recordings, smooth transitions, calm background music

---

### App Store Description (Marketing Copy)

**Headline:**
"Stay pain-free with gentle posture reminders"

**Subtitle:**
"Build healthy habits. Track your progress. Feel better."

**Description:**

The simplest way to improve your posture and reduce back pain.

PosturePal sends gentle reminders throughout your day to check your posture. 
No complicated sensors. No annoying alarms. Just calm, helpful nudges 
when you need them.

✨ FEATURES

SMART REMINDERS
• Customizable intervals (15-90 minutes)
• Automatic quiet hours
• Works in background reliably

STREAK TRACKING
• Build daily habits
• Celebrate milestones
• Track your consistency

APPLE WATCH
• Gentle haptic notifications
• Quick check-ins from your wrist
• Beautiful complications

BEAUTIFULLY DESIGNED
• Calm, minimal interface
• Dark mode support
• Home screen widgets

Perfect for desk workers, remote professionals, students, and anyone 
who spends hours at a computer.

Your back will thank you! 🙏

---

FREE VERSION includes:
• Basic hourly reminders
• 7-day streak tracking

PREMIUM ($4.99/month or $29.99/year) includes:
• Custom intervals (15-90 min)
• Unlimited streak tracking
• Apple Watch app
• Smart scheduling
• Quiet hours automation
• No ads

Start building better posture habits today!

**Keywords:**
posture, posture reminder, back pain, ergonomics, desk health, posture tracker, 
health habits, wellness, streak tracker, apple watch posture

---

## Animations & Micro-Interactions

### Check-In Animation

**Trigger:** User taps "Check My Posture Now" button

**Sequence:**
1. Button scales down (0.95) with haptic feedback (light impact)
2. Checkmark icon animates in with spring effect
3. New check-in card slides in from right
4. Streak number animates up if incremented
5. Success haptic (notification success)
6. Button returns to normal state

**Duration:** 800ms total

---

### Streak Milestone Celebration

**Trigger:** Check-in completes a milestone (7, 14, 30, 50, 100, 365 days)

**Sequence:**
1. Screen dims slightly (overlay)
2. Confetti bursts from top (particles fall with gravity)
3. Streak card pulses and scales up (1.05x)
4. "🎉 Amazing! 30 Day Streak!" toast appears centered
5. Haptic pattern (success + light impacts)
6. Confetti settles and fades out
7. Screen returns to normal

**Duration:** 3 seconds, dismissible by tap

**Confetti Colors:** Brand gradient colors (`#4A90E2`, `#66D9A6`, `#FFB84D`)

---

### Notification Arrival (iPhone)

**Banner:**
- Icon: App icon
- Title: "Posture Check 🧘"
- Body: "Time to check your posture! Tap to mark."
- Sound: Gentle chime (system default "Popcorn" or custom calm tone)

**Lock Screen:**
- Same as banner, persistent until dismissed or tapped

**Apple Watch:**
- Haptic: Gentle tap pattern (3 light taps)
- Display: "Posture Check" with check-in button
- Auto-dismiss: 30 seconds

---

### Loading States

**Initial App Launch:**
- Splash screen with app icon (500ms)
- Fade to onboarding or dashboard

**Pull to Refresh:**
- iOS native spinner (activity indicator)
- Color: `#4A90E2`

**Button Loading (saving settings):**
- Button text fades to spinner (activity indicator)
- Disabled state while loading
- Success checkmark briefly before re-enabling

---

## Dark Mode Strategy

**Approach:** Full dark mode support, auto-switches with system setting

**Key Changes for Dark Mode:**
- Backgrounds: Pure black (`#000000`) with elevated cards (`#1C1C1E`)
- Text: Invert hierarchy (white headings, light gray body)
- Colors: Slightly desaturated brand colors for reduced eye strain
  - Primary blue: `#5BA3F5` (lighter than light mode)
  - Success green: `#7BE3B5` (lighter)
- Shadows: Remove box shadows, use subtle borders (`#2C2C2E`) instead
- Icons: Inverse fill/outline (use outline icons in dark mode for clarity)

**Testing:** Verify all screens in both modes, ensure no hard-coded colors

**Asset Support:** Provide dark mode variants for illustrations (line art works in both)

---

## Accessibility

### VoiceOver Support

**All Interactive Elements:**
- Descriptive labels ("Check posture now" not just "Check")
- Hint text for complex actions
- Streak counter: "42 day streak, tap to view history"

**Custom Actions:**
- Swipe actions announced clearly
- Non-visual feedback for check-ins (haptic + VoiceOver confirmation)

### Dynamic Type

**Support iOS text size settings:**
- All text uses SF Pro with dynamic sizing
- UI scales gracefully from -2 to +5 size classes
- Buttons maintain minimum 44pt touch target
- Cards expand vertically as needed

### Color Contrast

**WCAG AA Compliance:**
- All text meets 4.5:1 contrast ratio (7:1 for headings)
- Buttons meet 3:1 contrast against background
- Icons paired with text labels for clarity

**Testing:**
- Use Xcode Accessibility Inspector
- Test with Color Blindness simulator (red/green deficiency)
- Verify all states (default, hover, pressed, disabled)

### Reduced Motion

**For users with motion sensitivity:**
- Disable confetti animation (replace with static celebration screen)
- Reduce spring animations to simple fades
- Keep haptics (non-visual)

**Implementation:** Respect `UIAccessibility.isReduceMotionEnabled`

---

## Platform-Specific Considerations

### iPhone (Primary Platform)

**Sizes to Support:**
- iPhone SE (4.7" - 375pt width) - Minimum target
- iPhone 15 (6.1" - 393pt width) - Most common
- iPhone 15 Pro Max (6.7" - 430pt width) - Largest

**Safe Areas:**
- Respect notch/Dynamic Island
- Bottom home indicator (21pt padding)
- Landscape mode: Minimal (show only essential UI)

### iPad (Future Support - Not MVP)

**Considerations for later:**
- Split view / multitasking
- Larger layouts (2-column views)
- Keyboard shortcuts
- Pointer support

### Apple Watch (MVP Feature)

**Sizes:**
- 40mm and 44mm (current models)

**Constraints:**
- Small screen (162pt / 184pt width)
- Glanceable info only
- One primary action per screen
- Haptic-first interaction

**Complications:**
- Support Circular, Rectangular, Corner
- Update every 15 minutes (iOS limitation)
- Show streak number + icon

---

## Motion & Haptics

### Haptic Feedback Patterns

**Check-In Success:**
```swift
UINotificationFeedbackGenerator().notificationOccurred(.success)
```

**Button Tap:**
```swift
UIImpactFeedbackGenerator(style: .light).impactOccurred()
```

**Milestone Celebration:**
```swift
// Custom pattern
let generator = UINotificationFeedbackGenerator()
generator.notificationOccurred(.success)
DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    generator.notificationOccurred(.success)
}
```

**Slider Adjustment:**
```swift
UISelectionFeedbackGenerator().selectionChanged()
```

**Apple Watch Haptic (Check-In):**
```swift
WKInterfaceDevice.current().play(.notification)
```

---

## Export & Handoff

### Design Deliverables for Development

**Figma/Sketch File Structure:**
```
/PosturePal-Design
  /Screens
    - Onboarding (3 artboards)
    - Dashboard
    - Settings
    - Apple Watch
  /Components
    - Buttons
    - Cards
    - Typography samples
    - Color swatches
  /Assets
    - App Icon (all sizes)
    - SF Symbols mapping
    - Illustrations (SVG)
  /Marketing
    - Screenshots (5 variants)
    - App Store icon
```

**Export Specifications:**
- iOS assets: @1x, @2x, @3x (PNG for rasters, PDF for vectors)
- App icon: All required sizes in Asset Catalog format
- Colors: Exact hex codes documented
- Spacing: Documented in pt (iOS standard)

### Developer Handoff Checklist

✅ Design file with all screens (annotated)  
✅ Component library (reusable elements)  
✅ Color palette (hex codes)  
✅ Typography scale (pt sizes, weights)  
✅ Spacing system (4pt grid documented)  
✅ Animation specifications (duration, easing)  
✅ Haptic patterns (which feedback for which action)  
✅ Accessibility requirements (VoiceOver labels, contrast)  
✅ Dark mode variants  
✅ App Store assets (icon, screenshots, preview video)  
✅ Copy for all UI text and onboarding  

---

## Revision History

**v1.0 - 2026-02-28**
- Initial design system created
- All MVP screens designed
- Component library established
- Dark mode strategy defined
- Accessibility guidelines added

---

**END OF DESIGN SYSTEM**

This specification is ready for implementation. All colors, spacing, and components are production-ready. Designers and developers should reference this as the single source of truth for visual design decisions.
