#!/usr/bin/env bash

# Load .env to customize the installation
if [ -f .env.sh ]; then
  source .env.sh
fi

source ~/.dotfiles/utils/utils.sh

echo "==============================================="
echo "=============== D's DOTFILES =================="
echo "==============================================="

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
  ~/.dotfiles/install/arch.sh
elif [[ "$CURRENT_DISTRO" == "debian" ]]; then
  ~/.dotfiles/install/debian.sh
elif [[ "$CURRENT_DISTRO" == "ubuntu" ]]; then
  ~/.dotfiles/install/ubuntu.sh
elif [[ "$CURRENT_OS" == "macos" ]]; then
  ~/.dotfiles/install/macos.sh
else
  echo "❌ Unsupported distro: '$CURRENT_DISTRO'" >&2
  exit 1
fi
