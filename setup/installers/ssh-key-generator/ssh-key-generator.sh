#!/bin/bash

# SSH Key Generator for GitHub
# Main entry point - detects OS and delegates to OS-specific script
# Based on: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

# Load utilities for OS detection (same pattern as main.sh)
source ~/.dotfiles/utils/utils.sh

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Main execution
main() {
  echo "OS: $CURRENT_OS"
  echo "DISTRO: $CURRENT_DISTRO"
  echo ""

  # Delegate to OS-specific script based on detection
  # Same pattern as main.sh: check CURRENT_DISTRO first, then CURRENT_OS
  if [[ "$CURRENT_DISTRO" == "arch" ]] || [[ "$CURRENT_DISTRO" == "debian" ]] || [[ "$CURRENT_DISTRO" == "ubuntu" ]]; then
    # Linux distros
    bash "$SCRIPT_DIR/linux.sh"
  elif [[ "$CURRENT_OS" == "macos" ]]; then
    # macOS
    bash "$SCRIPT_DIR/macos.sh"
  elif [[ "$CURRENT_OS" == "linux" ]]; then
    # Generic Linux (includes WSL)
    bash "$SCRIPT_DIR/linux.sh"
  else
    echo "❌ Unsupported operating system: '$CURRENT_OS' (distro: '$CURRENT_DISTRO')" >&2
    exit 1
  fi
}

# Run main
main
