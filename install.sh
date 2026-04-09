#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/wthwang-iotrust/speckit.git"
GLOBAL_DIR="$HOME/.claude/skills/speckit"
LOCAL_DIR=".claude/skills/speckit"

usage() {
  echo "Usage: install.sh [--local]"
  echo ""
  echo "  (default)  Install globally to $GLOBAL_DIR"
  echo "  --local    Install into current project at $LOCAL_DIR"
}

MODE="global"
INSTALL_DIR="$GLOBAL_DIR"

for arg in "$@"; do
  case "$arg" in
    --local) MODE="local"; INSTALL_DIR="$LOCAL_DIR" ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $arg"; usage; exit 1 ;;
  esac
done

echo "speckit installer"
echo "================="
echo "Mode: $MODE → $INSTALL_DIR"
echo ""

# Check git
if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git is required but not installed."
  exit 1
fi

# Install or update
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "Updating existing installation..."
  cd "$INSTALL_DIR"

  # Migration: v0.3.x → v0.4.0 (flat attributes → domains/)
  if [ -d "attributes" ] && [ ! -d "domains" ]; then
    echo ""
    echo "Migrating v0.3.x → v0.4.0 structure..."
    echo "(Your presets/custom.json is preserved)"
  fi

  git pull --ff-only 2>/dev/null || {
    echo "WARNING: git pull failed (local changes?)."
    echo "Fix manually:"
    echo "  cd $INSTALL_DIR"
    echo "  git stash && git pull && git stash pop"
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
  echo "Installing..."
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --depth 1 "$REPO" "$INSTALL_DIR"
  echo ""
  echo "Installed speckit $(cat "$INSTALL_DIR/VERSION" 2>/dev/null || echo 'unknown')."
fi

echo ""
echo "Next: add this to your project's CLAUDE.md:"
echo ""
echo "  ## Skill routing"
echo "  - Any implementation request → invoke speckit"
echo ""
echo "Update:  cd $INSTALL_DIR && git pull"
echo "Install: curl -fsSL https://raw.githubusercontent.com/wthwang-iotrust/speckit/main/install.sh | bash"
