#!/bin/bash

set -euo pipefail

# Resolve Homebrew bash path by architecture
if [[ "$(uname -m)" == "arm64" ]]; then
  BREW_BASH="/opt/homebrew/bin/bash"
else
  BREW_BASH="/usr/local/bin/bash"
fi

# Add only if missing
if ! grep -Fxq "$BREW_BASH" /etc/shells; then
  echo "==> 🔐 Adding $BREW_BASH to /etc/shells"
  echo "$BREW_BASH" | sudo tee -a /etc/shells >/dev/null
  echo "==> ✅ Added"
else
  echo "==> ✅ $BREW_BASH already present in /etc/shells"
fi
