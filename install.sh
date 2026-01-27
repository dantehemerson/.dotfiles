#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/dantehemerson/dotfiles.git"

# Ensure dependencies
if ! command -v git >/dev/null 2>&1; then
  echo "✗ git is required but not installed"
  exit 1
fi

# Clone or update
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "→ Cloning dotfiles repository..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  echo "→ Dotfiles already exist, updating..."
  git -C "$DOTFILES_DIR" pull --ff-only
fi

cd "$DOTFILES_DIR"

echo "→ Running main installer..."
exec bash ./main.sh
