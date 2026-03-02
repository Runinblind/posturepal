# Quick Start - GitHub Actions (No Mac Needed!)

**Time to first build:** 15 minutes  
**Cost:** FREE (2,000 minutes/month)

---

## ⚡ 3-Step Quick Start

### Step 1: Create GitHub Repository (2 minutes)

**Via Website:**
1. Go to: https://github.com/new
2. Name: `posturepal-pro`
3. Visibility: Private
4. Click **Create repository**

**Via CLI:**
```bash
cd ~/.openclaw/workspace/projects/jarvis-app-dev/projects/posture-app
gh auth login
gh repo create posturepal-pro --private --source=. --remote=origin
```

---

### Step 2: Push Code (3 minutes)

```bash
cd ~/.openclaw/workspace/projects/jarvis-app-dev/projects/posture-app

# Initialize if needed
git init
git branch -M main

# Add all files
git add .

# Commit
git commit -m "Initial commit - PosturePal Pro

- 29 Swift files (7,302 lines)
- Complete iOS + Watch + Widgets
- GitHub Actions CI/CD
- Ready for automated builds"

# Push (replace USERNAME with your GitHub username)
git remote add origin https://github.com/USERNAME/posturepal-pro.git
git push -u origin main
```

**Or if already initialized:**
```bash
git add .
git commit -m "Add GitHub Actions workflows"
git push
```

---

### Step 3: Watch Build (10 minutes)

1. Go to: https://github.com/USERNAME/posturepal-pro/actions
2. Click on **iOS Build & Test** workflow
3. Watch real-time logs:
   - ✅ Checkout code
   - ✅ Setup Xcode
   - 🔄 Build iOS app (~5 min)
   - 🔄 Build Watch app (~2 min)
   - 🔄 Run tests (~2 min)
   - ✅ Upload artifact

**First build:** ~10-15 minutes (downloads dependencies)  
**Subsequent builds:** ~5-8 minutes (cached)

---

## 📦 Download Built App

**After build completes:**

1. Click on **completed workflow**
2. Scroll to **Artifacts** section (bottom)
3. Download: **PosturePalPro-Simulator-Build.zip**
4. Unzip → You have `PosturePalPro-Simulator.xcarchive`

**To test (requires Mac with Xcode):**
```bash
# On a Mac:
xcrun simctl install booted /path/to/PosturePalPro-Simulator.xcarchive
```

**Or:** Drag .app file into iOS Simulator

---

## 🎯 What You Get

✅ **Automated builds** on every push  
✅ **Free** macOS runners (2,000 min/month)  
✅ **No Mac needed** for development  
✅ **Downloadable artifacts** for testing  
✅ **Professional CI/CD** from day one  

---

## 🔄 Daily Workflow

```bash
# Make changes to code
vim src/Views/DashboardView.swift

# Commit & push
git add .
git commit -m "Improve dashboard UI"
git push

# Build starts automatically!
# Check: https://github.com/USERNAME/posturepal-pro/actions
# Download artifact when done
```

---

## 🚀 TestFlight Deployment (Optional - Future)

**When ready for TestFlight:**

### 1. Get Apple Developer Account
- Cost: $99/year
- Sign up: https://developer.apple.com

### 2. Add Secrets to GitHub
- See: [GITHUB-ACTIONS-SETUP.md](GITHUB-ACTIONS-SETUP.md) Step 6
- Required: API keys, certificates, provisioning profiles

### 3. Tag a Release
```bash
git tag v1.0.0
git push origin v1.0.0

# TestFlight deployment starts automatically!
# App available in TestFlight in ~30 minutes
```

---

## 📊 Build Status

**Monitor builds:**
- Live logs: https://github.com/USERNAME/posturepal-pro/actions
- Badge in README shows build status
- Email notifications on failure (configure in settings)

**Build artifacts:**
- Retention: 30 days (simulator builds)
- Retention: 90 days (release IPAs)
- Download from Actions → Workflow → Artifacts

---

## 🐛 Troubleshooting

### Build fails: "Permission denied"
```bash
# Fix: Enable Actions in repo settings
# Settings → Actions → General → Allow all actions
```

### Build fails: "No scheme found"
```bash
# Need to create Xcode project first
# Follow: INTEGRATION-ROADMAP.md
# Or I can generate project structure
```

### Can't download artifact
```bash
# Must be logged into GitHub
# Artifacts only visible to repo collaborators
```

### Want to modify build
```bash
# Edit: .github/workflows/ios-build.yml
# Change: Xcode version, iOS version, build steps
# Commit & push to apply changes
```

---

## 💡 Tips

**Speed up builds:**
- Cache is enabled automatically
- First build: 10-15 min
- Subsequent: 5-8 min (cached dependencies)

**Save minutes:**
- Only push when ready (each push = 1 build)
- Use pull requests for testing (builds on PR)
- Manual triggers for experiments (Actions → Run workflow)

**Free limits:**
- 2,000 minutes/month = 200 macOS minutes
- ~20 full builds per month
- More than enough for development!

**Upgrade if needed:**
- $0.008/minute over limit
- Usually not necessary unless heavy usage

---

## ✅ Success Checklist

After following quick start:
- [ ] GitHub repository created
- [ ] Code pushed to GitHub
- [ ] Actions tab shows workflow
- [ ] First build completed
- [ ] Artifact downloaded (optional)
- [ ] Badge shows passing in README

**You now have:** Automated iOS builds without a Mac! 🎉

---

## 📚 Full Documentation

**More details:**
- [GITHUB-ACTIONS-SETUP.md](GITHUB-ACTIONS-SETUP.md) - Complete guide
- [README.md](README.md) - Project overview
- [INTEGRATION-ROADMAP.md](INTEGRATION-ROADMAP.md) - Xcode integration
- [.github/workflows/ios-build.yml](.github/workflows/ios-build.yml) - Build workflow

---

## 🎯 Next Steps

**Today:**
1. ✅ Create GitHub repo
2. ✅ Push code
3. ✅ Watch first build
4. ✅ Download artifact

**This Week:**
1. Make code improvements
2. Push changes
3. Auto-builds validate
4. Download & test

**Launch (6 weeks):**
1. Get Apple Developer Account
2. Configure TestFlight
3. Beta test
4. Submit to App Store
5. Launch! 🚀

---

**Ready?** Run the commands above and watch your app build! ⚡

**Questions?** Check [GITHUB-ACTIONS-SETUP.md](GITHUB-ACTIONS-SETUP.md) for detailed help.
