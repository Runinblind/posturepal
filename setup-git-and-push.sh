#!/bin/bash
# PosturePal Pro - Automated Git Setup & Push
# Review this script before running!

set -e  # Exit on any error

echo "🔧 PosturePal Pro - Git Setup & GitHub Push"
echo "==========================================="
echo ""

# === STEP 1: Configure Git (if needed) ===
echo "📝 Step 1: Configuring Git..."

# Check if git user is configured
if [ -z "$(git config --global user.name)" ]; then
    read -p "Enter your name (for git commits): " GIT_NAME
    git config --global user.name "$GIT_NAME"
    echo "✅ Git name set to: $GIT_NAME"
else
    echo "✅ Git name already set: $(git config --global user.name)"
fi

if [ -z "$(git config --global user.email)" ]; then
    read -p "Enter your email (for git commits): " GIT_EMAIL
    git config --global user.email "$GIT_EMAIL"
    echo "✅ Git email set to: $GIT_EMAIL"
else
    echo "✅ Git email already set: $(git config --global user.email)"
fi

echo ""

# === STEP 2: Get GitHub Info ===
echo "📋 Step 2: GitHub Repository Info..."
echo ""
echo "Choose an option:"
echo "  1) Create NEW repository (posturepal-pro)"
echo "  2) Push to EXISTING repository"
echo ""
read -p "Enter choice (1 or 2): " REPO_CHOICE

if [ "$REPO_CHOICE" = "1" ]; then
    # New repository
    read -p "Enter your GitHub username: " GITHUB_USER
    REPO_NAME="posturepal-pro"
    REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"
    
    echo ""
    echo "📦 Will create new repo at: $REPO_URL"
    echo ""
    echo "⚠️  You'll need to:"
    echo "   1. Go to https://github.com/new"
    echo "   2. Create repo named: $REPO_NAME"
    echo "   3. Make it Private"
    echo "   4. Don't initialize (no README/gitignore)"
    echo ""
    read -p "Press ENTER when repo is created (or Ctrl+C to cancel)..."
    
elif [ "$REPO_CHOICE" = "2" ]; then
    # Existing repository
    read -p "Enter your GitHub username: " GITHUB_USER
    read -p "Enter repository name: " REPO_NAME
    REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"
    
    echo ""
    echo "📦 Will push to existing repo: $REPO_URL"
    echo ""
    read -p "Is this correct? (y/n): " CONFIRM
    if [ "$CONFIRM" != "y" ]; then
        echo "❌ Cancelled"
        exit 1
    fi
else
    echo "❌ Invalid choice"
    exit 1
fi

echo ""

# === STEP 3: Initialize Git ===
echo "📂 Step 3: Initializing Git repository..."

cd ~/.openclaw/workspace/projects/jarvis-app-dev/projects/posture-app

if [ ! -d ".git" ]; then
    git init
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

# Set main branch
git branch -M main
echo "✅ Branch set to: main"

echo ""

# === STEP 4: Add Remote ===
echo "🔗 Step 4: Adding GitHub remote..."

# Remove existing origin if exists
git remote remove origin 2>/dev/null || true

git remote add origin "$REPO_URL"
echo "✅ Remote added: $REPO_URL"

echo ""

# === STEP 5: Stage Files ===
echo "📦 Step 5: Staging files for commit..."

git add .
echo "✅ Files staged"

# Show what will be committed
echo ""
echo "📋 Files to be committed:"
git status --short | head -20
FILE_COUNT=$(git status --short | wc -l)
echo "   ... and $FILE_COUNT total files"

echo ""

# === STEP 6: Commit ===
echo "💾 Step 6: Creating commit..."

COMMIT_MESSAGE="Initial commit - PosturePal Pro complete codebase

- 29 Swift files (7,302 lines)
- Complete iOS + Watch + Widgets
- GitHub Actions CI/CD
- RevenueCat subscription integration
- QA test plans
- Marketing & ASO strategies
- All documentation

Built with JARVIS AI assistant (OpenClaw)"

git commit -m "$COMMIT_MESSAGE"
echo "✅ Commit created"

echo ""

# === STEP 7: Push to GitHub ===
echo "🚀 Step 7: Pushing to GitHub..."
echo ""
echo "⚠️  You may be prompted for GitHub credentials:"
echo "   - Username: $GITHUB_USER"
echo "   - Password: Use Personal Access Token (NOT your password!)"
echo ""
echo "📝 To create Personal Access Token:"
echo "   1. Go to: https://github.com/settings/tokens"
echo "   2. Generate new token (classic)"
echo "   3. Select scopes: repo (all)"
echo "   4. Copy token and paste when prompted"
echo ""
read -p "Press ENTER to push (or Ctrl+C to cancel)..."

git push -u origin main

echo ""
echo "✅ SUCCESS! Code pushed to GitHub!"
echo ""
echo "🎉 Next steps:"
echo "   1. Visit: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "   2. Go to Actions tab"
echo "   3. Watch your first build run!"
echo ""
echo "   Build will take ~10-15 minutes"
echo "   Then download artifact from Actions tab"
echo ""
echo "🚀 Your iOS app is building on GitHub's macOS runners!"
