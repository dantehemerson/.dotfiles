#!/bin/bash

set -euo pipefail

ZED_CLI_PATH="/Applications/Zed.app/Contents/MacOS/cli"
SYMLINK_PATH="/usr/local/bin/zed"

echo "==> 🔧 Installing Zed CLI..."

# Check if Zed.app exists
if [[ ! -f "$ZED_CLI_PATH" ]]; then
  echo "==> ❌ Zed.app not found at /Applications/Zed.app"
  echo "==> ℹ️  Please install Zed first from https://zed.dev"
  exit 1
fi

# Check if already installed
if command -v zed &> /dev/null; then
  echo "==> ✅ Zed CLI already installed at: $(which zed)"
  zed --version
  exit 0
fi

# Create symlink (requires sudo for /usr/local/bin)
echo "==> 📦 Creating symlink..."
sudo mkdir -p /usr/local/bin
sudo ln -sf "$ZED_CLI_PATH" "$SYMLINK_PATH"

# Verify installation
if command -v zed &> /dev/null; then
  echo "==> ✅ Zed CLI installed successfully!"
  zed --version
else
  echo "==> ❌ Installation failed"
  exit 1
fi
