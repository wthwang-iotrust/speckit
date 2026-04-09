#!/usr/bin/env bash
set -e

REPO="https://github.com/wthwang-iotrust/speckit.git"
INSTALL_DIR="$HOME/.claude/skills/speckit"

echo "speckit installer"
echo "================="

# Check git
if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git is required but not installed."
  exit 1
fi

# Install or update
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "Updating existing installation..."
  cd "$INSTALL_DIR"
  git pull --ff-only 2>/dev/null || {
    echo "WARNING: git pull failed (local changes?). Run manually:"
    echo "  cd $INSTALL_DIR && git stash && git pull && git stash pop"
    exit 1
  }
  echo ""
  echo "Updated to $(cat VERSION 2>/dev/null || echo 'unknown')."
else
  if [ -d "$INSTALL_DIR" ]; then
    echo "WARNING: $INSTALL_DIR exists but is not a git repo."
    echo "Remove it first: rm -rf $INSTALL_DIR"
    exit 1
  fi
  echo "Installing to $INSTALL_DIR..."
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --depth 1 "$REPO" "$INSTALL_DIR"
  echo ""
  echo "Installed speckit $(cat "$INSTALL_DIR/VERSION" 2>/dev/null || echo 'unknown')."
fi

echo ""
echo "Next: add this to your project's CLAUDE.md:"
echo ""
echo "  ## Skill routing"
echo "  - Any implementation request → invoke spec"
echo ""
echo "Update anytime: $0"
echo "Or manually:    cd $INSTALL_DIR && git pull"
