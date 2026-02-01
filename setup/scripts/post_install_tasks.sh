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

echo "==> ✅ Post-install configuration complete"
