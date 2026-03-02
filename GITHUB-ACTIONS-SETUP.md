# GitHub Actions Setup Guide - PosturePal Pro

**No Mac needed!** Automated builds on GitHub's macOS runners.

---

## 🎯 What You Get

✅ **Automated Builds** - Every commit triggers a build  
✅ **Free** - 2,000 minutes/month (enough for ~100 builds)  
✅ **No Setup** - macOS + Xcode pre-installed  
✅ **Simulator Builds** - Download and test  
✅ **TestFlight** - Optional automated deployment  

---

## 📋 Step 1: Create GitHub Repository (5 minutes)

### Option A: GitHub Website

1. **Go to:** https://github.com/new
2. **Repository name:** posturepal-pro
3. **Visibility:** Private (recommended) or Public
4. **Initialize:** ❌ Don't initialize (we have files already)
5. Click **Create repository**

### Option B: GitHub CLI

```bash
cd ~/.openclaw/workspace/projects/jarvis-app-dev/projects/posture-app

# Install gh if needed
# sudo apt install gh

gh auth login
gh repo create posturepal-pro --private --source=. --remote=origin
```

---

## 📋 Step 2: Push Code to GitHub (2 minutes)

```bash
cd ~/.openclaw/workspace/projects/jarvis-app-dev/projects/posture-app

# Initialize git if not done
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - PosturePal Pro complete codebase

- 29 Swift files (7,302 lines)
- Complete feature set (Weeks 1-5)
- GitHub Actions workflows
- Ready for automated builds"

# Add remote (replace USERNAME with your GitHub username)
git remote add origin https://github.com/USERNAME/posturepal-pro.git

# Push to GitHub
git push -u origin main
```

**Alternative branches:**
```bash
# If you get "main doesn't exist", use:
git branch -M main
git push -u origin main
```

---

## 📋 Step 3: Verify GitHub Actions (1 minute)

### Check Workflow File

GitHub Actions will automatically detect `.github/workflows/ios-build.yml`

**Verify:**
1. Go to: https://github.com/USERNAME/posturepal-pro
2. Click **Actions** tab
3. You should see "iOS Build & Test" workflow
4. First build will start automatically!

---

## 📋 Step 4: Monitor First Build (10-15 minutes)

### Watch Build Progress

1. **Actions** tab → Click on running workflow
2. **Watch real-time logs:**
   - Checkout Repository ✅
   - Setup Xcode ✅
   - Build iOS App 🔄
   - Build Watch App 🔄
   - Run Tests 🔄
   - Package Build ✅

**Expected time:** 10-15 minutes for first build (downloads dependencies)

**Subsequent builds:** 5-8 minutes (cached)

---

## 📋 Step 5: Download Built App (1 minute)

### After Build Succeeds

1. **Actions** tab → Click completed workflow
2. Scroll to **Artifacts** section
3. Download: **PosturePalPro-Simulator-Build.zip**
4. Unzip → `PosturePalPro-Simulator.xcarchive`

### Install in Simulator (Requires Mac)

```bash
# On a Mac with Xcode:
xcrun simctl install booted /path/to/PosturePalPro-Simulator.xcarchive

# Or open Simulator and drag .app file into it
```

**Note:** Simulator builds run in iOS Simulator only (not on physical iPhone).

---

## 📋 Step 6: Configure Secrets (For TestFlight)

**Optional:** Set up automated TestFlight deployment

### Required Secrets

1. **Go to:** Repository → Settings → Secrets and variables → Actions
2. **Click:** New repository secret
3. **Add these secrets:**

| Secret Name | Value | How to Get |
|-------------|-------|------------|
| `APP_STORE_CONNECT_KEY_ID` | API Key ID | App Store Connect → Keys |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID | App Store Connect → Keys |
| `APP_STORE_CONNECT_API_KEY` | API Key (base64) | Download .p8, convert to base64 |
| `DISTRIBUTION_CERTIFICATE` | Cert (base64) | Export from Mac Keychain |
| `CERTIFICATE_PASSWORD` | Cert password | Password you set |
| `PROVISIONING_PROFILE` | Profile (base64) | Download from Developer Portal |

### How to Get Secrets

#### App Store Connect API Key
```bash
# 1. Go to: https://appstoreconnect.apple.com/access/api
# 2. Create new key (Admin or App Manager role)
# 3. Download .p8 file
# 4. Convert to base64:
cat AuthKey_XXXXXXXX.p8 | base64 > api_key.txt
# 5. Copy contents of api_key.txt to secret
```

#### Distribution Certificate
```bash
# On a Mac:
# 1. Open Keychain Access
# 2. Find "Apple Distribution: Your Name"
# 3. Right-click → Export
# 4. Save as .p12 with password
# 5. Convert to base64:
cat Certificates.p12 | base64 > cert.txt
# 6. Copy contents to secret
```

#### Provisioning Profile
```bash
# 1. Go to: https://developer.apple.com/account/resources/profiles
# 2. Create Distribution profile for App Store
# 3. Download .mobileprovision
# 4. Convert to base64:
cat Profile.mobileprovision | base64 > profile.txt
# 5. Copy contents to secret
```

---

## 🚀 Workflow Options

### ios-build.yml (Automatic)

**Triggers:**
- Every push to `main` or `develop` branch
- Every pull request to `main`
- Manual trigger via Actions UI

**What it does:**
- ✅ Builds iOS app for simulator
- ✅ Builds Watch app
- ✅ Runs unit tests
- ✅ Uploads simulator build artifact

**Cost:** FREE (uses ~10 minutes per build)

---

### testflight-deploy.yml (Manual/Tagged)

**Triggers:**
- Version tags (e.g., `git tag v1.0.0`)
- Manual trigger via Actions UI

**What it does:**
- ✅ Builds release version
- ✅ Signs with distribution certificate
- ✅ Exports IPA file
- ✅ Uploads to TestFlight
- ✅ Creates GitHub release

**Cost:** FREE (uses ~15 minutes per deploy)

**Requirements:**
- Apple Developer Account ($99/year)
- Secrets configured (certificates, API keys)

---

## 💡 Usage Examples

### Regular Development

```bash
# Make changes to code
git add .
git commit -m "Add new feature"
git push

# Build starts automatically
# Download artifact from Actions tab
```

### TestFlight Release

```bash
# Update version in Xcode project
# Commit changes
git add .
git commit -m "Release v1.0.0"

# Create version tag
git tag v1.0.0
git push origin v1.0.0

# TestFlight deployment starts automatically
# App available in TestFlight in ~30 minutes
```

### Manual Trigger

1. Go to **Actions** tab
2. Select **iOS Build & Test** or **Deploy to TestFlight**
3. Click **Run workflow**
4. Choose branch
5. Click **Run workflow** button

---

## 🔧 Customization

### Change iOS Version

Edit `.github/workflows/ios-build.yml`:
```yaml
env:
  IOS_SIMULATOR: 'iPhone 15 Pro'  # Change device
  IOS_VERSION: '17.2'              # Change iOS version
```

### Add Build Steps

```yaml
- name: Custom Step
  run: |
    echo "Your custom commands here"
    # Run scripts, tests, validations
```

### Notifications

Add Slack/Discord notifications:
```yaml
- name: Notify on Success
  if: success()
  run: |
    curl -X POST ${{ secrets.SLACK_WEBHOOK }} \
      -d '{"text":"✅ iOS build successful!"}'
```

---

## 📊 GitHub Actions Limits

### Free Tier (Public Repos)
- ✅ 2,000 minutes/month
- ✅ ~100 full builds (simulator)
- ✅ ~80 TestFlight deploys
- ✅ Unlimited storage for 90 days

### Free Tier (Private Repos)
- ✅ 2,000 minutes/month (same as public)
- ✅ 500 MB storage

### Paid Tiers
- $0.008/minute over limit
- $0.25/GB storage
- Usually not needed unless heavy usage

### macOS Runner Specifics
- Each macOS minute = 10x multiplier
- 2,000 minutes = 200 minutes on macOS
- Still enough for ~10-20 builds per month

**For PosturePal Pro:**
- ~10 min per build × 10x = 100 minutes billed
- 2,000 minutes / 100 = 20 builds per month free
- More than enough for development!

---

## 🐛 Troubleshooting

### Build Fails: "Project not found"

**Issue:** Missing .xcodeproj file  
**Fix:** Need to create Xcode project first

**Solution:**
```bash
# I can generate the project structure
# Or follow INTEGRATION-ROADMAP.md to create manually on Mac
```

### Build Fails: "Provisioning profile not found"

**Issue:** Only matters for TestFlight (device builds)  
**Fix:** Simulator builds don't need signing  

**For TestFlight:** Add secrets (see Step 6)

### Build Fails: "Scheme not found"

**Issue:** Scheme name doesn't match  
**Fix:** Update workflow with correct scheme name

```yaml
# Check scheme name in Xcode
# Update workflow:
-scheme YourActualSchemeName
```

### Slow Builds

**Issue:** Dependencies downloading every time  
**Fix:** Cache is enabled, should improve after first build

```yaml
# Already included in workflow:
- name: Cache Swift Packages
  uses: actions/cache@v3
```

---

## 📈 Next Steps

### Immediate (After Push)
1. ✅ Push code to GitHub
2. ✅ Watch first build complete
3. ✅ Download simulator artifact
4. ✅ Verify build succeeded

### This Week (Development)
1. Make code changes
2. Push to GitHub
3. Auto-builds run
4. Download artifacts
5. Test in simulator (if you get Mac access)

### Before App Store (Future)
1. Get Apple Developer Account ($99)
2. Create certificates & profiles
3. Add secrets to GitHub
4. Tag a release version
5. Auto-deploy to TestFlight
6. Submit to App Store

---

## 🎯 Benefits of This Setup

✅ **No Mac needed** for development  
✅ **Free** automated builds  
✅ **Fast** 5-10 minute builds  
✅ **Consistent** same environment every time  
✅ **Scalable** team members can contribute  
✅ **Professional** CI/CD from day one  
✅ **TestFlight ready** when you need it  

---

## 📞 Get Help

**Workflow not running?**
- Check: Actions tab → Enable workflows if disabled
- Check: `.github/workflows/` files are committed

**Build failing?**
- Check: Actions → Click failed run → View logs
- Common issues documented above

**Need changes?**
- Ask me! I can modify workflows for your needs

---

## ✅ Success Criteria

After following this guide:
- [ ] Code pushed to GitHub
- [ ] Actions tab shows workflow
- [ ] First build completes successfully
- [ ] Artifact available for download
- [ ] Can trigger builds by pushing code

**You'll have:** Automated iOS builds without owning a Mac! 🎉

---

**Next:** Push your code and watch the magic happen!

```bash
cd ~/.openclaw/workspace/projects/jarvis-app-dev/projects/posture-app
git add .
git commit -m "Add GitHub Actions workflows"
git push
```

Then visit: https://github.com/USERNAME/posturepal-pro/actions
