#!/usr/bin/env bash
set -euo pipefail

# Deploy to GitHub Pages
# Usage: ./scripts/sync.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$ROOT_DIR/dist"

# Verify we are in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not inside a git repository"
    exit 1
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

echo "🚀 Deploying to GitHub Pages..."
echo "   Source branch: $CURRENT_BRANCH"

# Switch to gh-pages (create orphan if it doesn't exist)
if git rev-parse --verify gh-pages > /dev/null 2>&1; then
    git checkout gh-pages
else
    git checkout --orphan gh-pages
    git rm -rf . > /dev/null 2>&1 || true
fi

# Remove everything except .git
find . -mindepth 1 -not -path './.git/*' -not -name '.git' -delete

# Copy dist content
cp -r "$DIST_DIR"/* .

# Ensure .nojekyll for GitHub Pages
touch .nojekyll

# Commit and push
git add -A
git commit -m "Deploy: $(date -u +'%Y-%m-%d %H:%M:%S UTC')"
git push origin gh-pages --force

# Return to original branch
git checkout "$CURRENT_BRANCH"

echo ""
echo "✅ Deployed to https://$(git remote get-url origin | sed 's/.*github.com[:\/]//;s/\.git$//').github.io/proxy-rules/"
