# 🔧 Xcode Project Setup Guide

**For:** PosturePal Pro Week 1 Code  
**Time Required:** ~15 minutes  
**Prerequisites:** Xcode 15+ installed

---

## Step-by-Step Setup

### 1. Create New Project

1. Open Xcode
2. **File → New → Project**
3. Choose **iOS → App**
4. Fill in:
   - **Product Name:** PosturePal
   - **Organization Identifier:** com.yourcompany
   - **Interface:** SwiftUI ✅
   - **Language:** Swift ✅
   - **Storage:** Core Data ✅ (check this box!)
   - **Include Tests:** ✅ (optional, but recommended)

5. Click **Next**, choose location, click **Create**

---

### 2. Import Source Files

#### Option A: Drag and Drop (Easiest)

1. In Finder, open: `~/.openclaw/workspace/projects/jarvis-app-dev/projects/posture-app/src/`
2. In Xcode, delete the auto-generated:
   - `ContentView.swift`
   - `PosturePalApp.swift` (if it exists)
3. Drag the entire `src/` folder contents into Xcode project navigator
4. When prompted:
   - ✅ **Copy items if needed**
   - ✅ **Create groups**
   - ✅ **Add to targets: PosturePal**

#### Option B: Manual Copy (More Control)

```bash
# From terminal:
cd ~/path/to/your/xcode/project/PosturePal
cp -r ~/.openclaw/workspace/projects/jarvis-app-dev/projects/posture-app/src/* ./
```

Then in Xcode:
- **File → Add Files to "PosturePal"...**
- Select all copied files

---

### 3. Configure CoreData Model

The code expects a CoreData model named `PosturePal.xcdatamodeld`.

1. In Project Navigator, find `PosturePal.xcdatamodeld` (auto-created)
2. Click it to open the visual editor
3. Add entity `CheckIn`:

   **Entity Name:** `CheckIn`
   
   **Attributes:**
   | Name | Type | Optional | Indexed |
   |------|------|----------|---------|
   | `id` | UUID | No | Yes |
   | `timestamp` | Date | No | Yes |
   | `wasOnTime` | Boolean | No | No |

4. In the **Data Model Inspector** (right sidebar):
   - Set **Codegen** to `Manual/None` (we have our own class)

5. Save (⌘S)

---

### 4. Update Info.plist

Add notification permission keys:

1. Click `Info.plist` in Project Navigator
2. Right-click in the list → **Add Row**
3. Add:

```
Key: Privacy - User Notifications Usage Description
Type: String
Value: We need permission to send you gentle posture reminders throughout the day.
```

---

### 5. Fix Build Issues (If Any)

Common issues and fixes:

#### Issue: "Cannot find 'PersistenceController' in scope"

**Fix:** Make sure `Services/PersistenceController.swift` is in the project and added to target.

#### Issue: "Cannot find type 'CheckIn' in scope"

**Fix:** 
1. Select `PosturePal.xcdatamodeld`
2. Check that `CheckIn` entity exists
3. Clean build folder: **Product → Clean Build Folder** (⇧⌘K)

#### Issue: Color extension errors

**Fix:** Already included in `DashboardView.swift` - ensure file is imported.

---

### 6. Build and Run

1. Select target: **PosturePal** (iPhone 15 Pro simulator or your device)
2. Press **⌘R** to build and run
3. Expected flow:
   - Onboarding appears (3 pages)
   - Tap "Get Started" → notification permission prompt
   - Grant permission
   - Dashboard loads (0 day streak initially)

---

### 7. Test Core Features

Once running:

✅ **Test Onboarding:**
- Swipe through 3 pages
- Tap "Get Started"
- Grant notification permission

✅ **Test Check-In:**
- Tap "Check My Posture Now"
- Streak should increment to 1
- Haptic feedback should fire
- Check-in appears in "Today's Status"

✅ **Test Settings:**
- Tap gear icon (top right)
- Change interval (60min only in free tier)
- Toggle quiet hours
- Tap "Done" to save

✅ **Test Notifications:**
- Wait for interval (default 60 minutes)
- OR: set interval to 15min, upgrade to premium (hardcode `isPremium = true` in SettingsManager for testing)
- Notification should fire
- Tap notification → app opens, check-in triggered

---

## Optional: Enable Premium for Testing

To test premium features without RevenueCat:

1. Open `Models/UserSettings.swift`
2. In `SettingsManager` init, add:
   ```swift
   self.settings.isPremium = true  // Force premium for testing
   ```
3. Rebuild
4. Now you can select 15/30/45/90 minute intervals

**Remember:** Remove this before production!

---

## Troubleshooting

### Notifications Not Firing?

- **Simulator:** Some macOS/Xcode versions have buggy notification support. Test on real device.
- **Permissions:** Check Settings app → Notifications → PosturePal (should be enabled)
- **Scheduling:** Check console logs for "✅ Notification scheduled for: [date]"

### App Crashes on Launch?

- Check console for errors
- Common cause: CoreData model mismatch
  - Delete app from simulator
  - Clean build folder (⇧⌘K)
  - Rebuild

### "Module compiled with Swift X.X.X cannot be imported"

- Check **Build Settings → Swift Language Version**
- Set to: **Swift 5** or later

---

## Next Steps

Once everything builds and runs:

1. ✅ Test all features manually
2. ✅ Read `src/README-WEEK1.md` for Week 2 tasks
3. ✅ Refer to `specs/ARCHITECTURE.md` for full development plan
4. ✅ Follow Week 2-8 tasks to build remaining features

---

## File Structure Reference

After import, your Xcode project should look like:

```
PosturePal/
├── PosturePalApp.swift
├── Models/
│   ├── UserSettings.swift
│   ├── CheckIn.swift
│   └── StreakData.swift
├── Services/
│   ├── PersistenceController.swift
│   └── NotificationService.swift
├── ViewModels/
│   ├── DashboardViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingContainerView.swift
│   ├── Home/
│   │   └── DashboardView.swift
│   └── Settings/
│       └── SettingsView.swift
├── PosturePal.xcdatamodeld
├── Assets.xcassets/
├── Info.plist
└── README-WEEK1.md
```

---

## Need Help?

- **Documentation:** See `src/README-WEEK1.md`
- **Architecture:** See `specs/ARCHITECTURE.md`
- **Design:** See `design/DESIGN-SYSTEM.md`

🚀 **Happy coding!**
