#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"

echo "==> 🔧 Running post-install configuration..."

# Change git remote from HTTPS to SSH if needed
CURRENT_URL=$(git -C "$DOTFILES_DIR" remote get-url origin 2>/dev/null || true)

if [[ "$CURRENT_URL" == https://github.com/dantehemerson/dotfiles.git ]]; then
  echo "==> 🔄 Changing git remote from HTTPS to SSH..."
  git -C "$DOTFILES_DIR" remote set-url origin git@github.com:dantehemerson/dotfiles.git
  echo "==> ✅ Git remote changed to SSH"
elif [[ "$CURRENT_URL" == git@github.com:dantehemerson/dotfiles.git ]]; then
  echo "==> ✅ Git remote already using SSH"
else
  echo "==> ℹ️  Git remote URL is different: $CURRENT_URL"
fi

# Setup zed -> zeditor symlink if needed
if ! command -v zed &> /dev/null; then
  if command -v zeditor &> /dev/null; then
    ZEDITOR_PATH=$(which zeditor)
    mkdir -p "$HOME/.local/bin"
    ln -sf "$ZEDITOR_PATH" "$HOME/.local/bin/zed"
    echo "==> ✅ Created zed symlink to zeditor"
    
    # Warn if ~/.local/bin is not in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
      echo "==> ⚠️  Warning: $HOME/.local/bin is not in your PATH"
      echo "==>     Add 'export PATH=\"$HOME/.local/bin:$PATH\"' to your shell config"
    fi
  fi
fi

echo "==> ✅ Post-install configuration complete"

# Apply Herdr app layout/theme from dotfiles (layout choice is app-local state)
~/.dotfiles/setup/scripts/herdr_app_setup.sh
