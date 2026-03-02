# Info.plist Additions - PosturePal Pro

**File:** Add these entries to your Xcode project's Info.plist

---

## Required Entries

### 1. Privacy Descriptions (Permission Requests)

```xml
<!-- Notifications Permission -->
<key>NSUserNotificationsUsageDescription</key>
<string>PosturePal needs notification permission to send you posture reminders throughout the day.</string>

<!-- HealthKit Permission (Optional - if using) -->
<key>NSHealthShareUsageDescription</key>
<string>PosturePal can save your posture check-ins to Apple Health to track your wellness journey.</string>

<key>NSHealthUpdateUsageDescription</key>
<string>PosturePal will log your posture check-ins to Apple Health for comprehensive health tracking.</string>
```

---

### 2. Background Modes

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

---

### 3. App Transport Security (If needed)

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>
```

---

### 4. Privacy Policy & Support URLs

```xml
<!-- Privacy Policy URL -->
<key>NSPrivacyPolicyURL</key>
<string>https://yourwebsite.com/privacy</string>

<!-- Terms of Service URL -->
<key>NSTermsOfServiceURL</key>
<string>https://yourwebsite.com/terms</string>

<!-- Support URL -->
<key>NSSupportURL</key>
<string>https://yourwebsite.com/support</string>

<!-- or use email for support -->
<key>NSSupportEmail</key>
<string>support@posturepal.app</string>
```

---

### 5. App Category & Compatibility

```xml
<key>LSApplicationCategoryType</key>
<string>public.app-category.healthcare-fitness</string>

<key>UIRequiredDeviceCapabilities</key>
<array>
    <string>armv7</string>
</array>

<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationPortraitUpsideDown</string>
</array>
```

---

### 6. iTunes Connect / Encryption (Required for App Store)

```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

**Note:** Set to `<false/>` if you're NOT using custom encryption beyond Apple's standard encryption. This is correct for PosturePal Pro (we only use standard iOS encryption).

---

### 7. App Groups (Required for Widget)

```xml
<key>AppIdentifierPrefix</key>
<string>$(AppIdentifierPrefix)</string>
```

**In Capabilities Tab:**
- Enable "App Groups"
- Add: `group.com.yourcompany.posturepal`
- Make sure ALL targets (iPhone, Watch, Widget) use the SAME App Group ID

---

### 8. WatchKit Extension (If using Watch app)

```xml
<!-- In Watch Extension Info.plist -->
<key>WKCompanionAppBundleIdentifier</key>
<string>com.yourcompany.posturepal</string>

<key>WKExtensionDelegateClassName</key>
<string>$(PRODUCT_MODULE_NAME).ExtensionDelegate</string>

<key>WKWatchOnly</key>
<false/>
```

---

## Optional Entries

### 1. Custom URL Scheme (Deep Linking)

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.yourcompany.posturepal</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>posturepal</string>
        </array>
    </dict>
</array>
```

**Usage:** `posturepal://reminder/set` for deep links

---

### 2. Font Licenses (If using custom fonts)

```xml
<key>UIAppFonts</key>
<array>
    <string>CustomFont-Regular.ttf</string>
    <string>CustomFont-Bold.ttf</string>
</array>
```

---

### 3. Status Bar Style

```xml
<key>UIStatusBarStyle</key>
<string>UIStatusBarStyleDefault</string>

<key>UIViewControllerBasedStatusBarAppearance</key>
<true/>
```

---

### 4. Launch Screen (If using custom)

```xml
<key>UILaunchStoryboardName</key>
<string>LaunchScreen</string>
```

---

## Complete Example Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- App Info -->
    <key>CFBundleDisplayName</key>
    <string>PosturePal Pro</string>
    
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    
    <key>CFBundleVersion</key>
    <string>1</string>
    
    <!-- Privacy Descriptions -->
    <key>NSUserNotificationsUsageDescription</key>
    <string>PosturePal needs notification permission to send you posture reminders throughout the day.</string>
    
    <key>NSHealthShareUsageDescription</key>
    <string>PosturePal can save your posture check-ins to Apple Health to track your wellness journey.</string>
    
    <key>NSHealthUpdateUsageDescription</key>
    <string>PosturePal will log your posture check-ins to Apple Health for comprehensive health tracking.</string>
    
    <!-- URLs -->
    <key>NSPrivacyPolicyURL</key>
    <string>https://yourwebsite.com/privacy</string>
    
    <key>NSTermsOfServiceURL</key>
    <string>https://yourwebsite.com/terms</string>
    
    <key>NSSupportEmail</key>
    <string>support@posturepal.app</string>
    
    <!-- Background Modes -->
    <key>UIBackgroundModes</key>
    <array>
        <string>fetch</string>
        <string>remote-notification</string>
    </array>
    
    <!-- Encryption -->
    <key>ITSAppUsesNonExemptEncryption</key>
    <false/>
    
    <!-- Category -->
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.healthcare-fitness</string>
    
    <!-- Orientation -->
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
    
</dict>
</plist>
```

---

## How to Add in Xcode

### Method 1: Xcode UI
1. Select project in Navigator
2. Select target (PosturePal Pro)
3. Info tab
4. Click "+" to add new entry
5. Type key name (e.g., `NSUserNotificationsUsageDescription`)
6. Add value (the description text)

### Method 2: Direct Edit
1. Right-click Info.plist in Navigator
2. "Open As" → "Source Code"
3. Paste XML entries between `<dict>` tags
4. Save

---

## Validation Checklist

Before App Store submission, verify:
- [ ] All privacy descriptions present (notifications, HealthKit if used)
- [ ] Privacy policy URL works
- [ ] Terms of service URL works  
- [ ] Support email/URL works
- [ ] ITSAppUsesNonExemptEncryption set correctly
- [ ] App category is correct
- [ ] App Groups enabled (same ID across all targets)
- [ ] Bundle IDs match App Store Connect

---

## Common Issues

**Issue:** "Missing NSUserNotificationsUsageDescription"
- **Fix:** Add notification permission description

**Issue:** "Invalid URL in Info.plist"
- **Fix:** Make sure URLs start with https:// and are accessible

**Issue:** Widget not updating
- **Fix:** Verify App Groups capability enabled with same ID

**Issue:** Watch app not appearing
- **Fix:** Check WKCompanionAppBundleIdentifier matches main app

---

**Remember:** Replace placeholder URLs and email with your actual values before submission!
