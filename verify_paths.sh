#!/bin/bash

echo "=== Verification of Xcode Project Paths ==="
echo ""

echo "1. Build Settings - INFOPLIST_FILE paths:"
grep "INFOPLIST_FILE" PosturePalPro.xcodeproj/project.pbxproj | sort -u

echo ""
echo "2. File References - Info.plist paths:"
grep -E "G000000[123]000000000000001.*Info.plist" PosturePalPro.xcodeproj/project.pbxproj

echo ""
echo "3. Entitlements in Build Settings:"
grep "CODE_SIGN_ENTITLEMENTS" PosturePalPro.xcodeproj/project.pbxproj | sort -u

echo ""
echo "4. Actual files on disk:"
for file in "PosturePalPro.entitlements" "PosturePalWatch.entitlements" "PosturePalPro/Info.plist" "PosturePal Watch/Info.plist" "PosturePalWidget/Info.plist"; do
    if [ -e "$file" ]; then
        echo "✓ $file"
    else
        echo "✗ MISSING: $file"
    fi
done

echo ""
echo "=== Verification Complete ==="
