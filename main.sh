#!/bin/bash

# Load .env to customize the installation
if [ -f .env.sh ]; then
  source .env.sh
fi

source ~/.dotfiles/utils/utils.sh

echo "==============================================="
echo "=============== D's DOTFILES =================="
echo "==============================================="

# Function to handle curl installations like starship
install_from_curl() {
  local url="$1"
  local name="$2"

  echo "Installing $name from curl..."
  if curl -sS "$url" | sh; then
    echo "✓ $name installed successfully"
  else
    echo "✗ Failed to install $name"
    return 1
  fi
}

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

echo "OS: $CURRENT_OS"
echo "ARCH: $CURRENT_ARCH"
echo "PM: $CURRENT_PM"
echo "DISTRO: $CURRENT_DISTRO"

if [[ "$CURRENT_DISTRO" == "arch" ]]; then
  ./install/arch.sh
  # ./linux/1_install_apps.linux.sh
  # ./linux/2_link_user_files.linux.sh

elif [[ "$CURRENT_DISTRO" == "macos" ]]; then

  # ./macos/1_install_apps.osx.sh
  # ./macos/2_configure.osx.sh
fi

# Install starship
install_from_curl "https://starship.rs/install.sh" "starship"

# Cleanup if we used temp dir for piped install
if [[ ! -t 0 ]]; then
  cd ~
  rm -rf "$TEMP_DIR"
fi
