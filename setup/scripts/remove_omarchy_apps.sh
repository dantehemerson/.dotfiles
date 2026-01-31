#!/bin/bash

# Based on: https://github.com/maxart/omarchy-cleaner/blob/main/omarchy-cleaner.sh
# It removes the the list of apps and webapps on marchy defined bellow:

# App
# List from: https://github.com/basecamp/omarchy/blob/master/install/packages.sh
DEFAULT_APPS=(
  "1password-beta"
  "1password-cli"
  "kdenlive"
  "libreoffice"
  "localsend"
  "obs-studio"
  "obsidian"
  # "omarchy-chromium"
  "signal-desktop"
  "spotify"
  "xournalpp"
  #"docker"
  #"docker-buildx"
  #"docker-compose"
  "alacritty"
)

# Webapps
# List from: https://github.com/basecamp/omarchy/blob/master/install/packaging/webapps.sh
DEFAULT_WEBAPPS=(
  "HEY"
  "Basecamp"
  "WhatsApp"
  "Google Photos"
  "Google Contacts"
  "Google Messages"
  "ChatGPT"
  "YouTube"
  "GitHub"
  "X"
  "Figma"
  "Discord"
  "Zoom"
)

# Function to check if package is installed
is_package_installed() {
  local package="$1"
  pacman -Qi "$package" &>/dev/null
  return $?
}

# Function to check if webapp is installed
is_webapp_installed() {
  local webapp="$1"
  # Check if .desktop file exists for the webapp
  local desktop_file="$HOME/.local/share/applications/$webapp.desktop"
  [[ -f "$desktop_file" ]]
  return $?
}
