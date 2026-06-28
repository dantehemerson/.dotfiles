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

# Function to remove a package
remove_package() {
  local pkg="$1"
  if ! is_package_installed "$pkg"; then
    echo "Skipping $pkg (not installed)"
    return 0
  fi
  echo "Removing package: $pkg"
  sudo pacman -Rns --noconfirm "$pkg"
}

# Function to remove a webapp
remove_webapp() {
  local webapp="$1"
  if ! is_webapp_installed "$webapp"; then
    echo "Skipping webapp '$webapp' (not installed)"
    return 0
  fi

  # Check if omarchy-webapp-remove command exists (not available in plain Arch)
  if ! command -v omarchy-webapp-remove &>/dev/null; then
    echo "Skipping webapp '$webapp' (omarchy-webapp-remove not available)"
    return 0
  fi

  echo "Removing webapp: $webapp"
  bash -c "omarchy-webapp-remove '$webapp'"
}

# Main execution
main() {
  echo "=== Removing Omarchy Apps ==="
  for pkg in "${DEFAULT_APPS[@]}"; do
    remove_package "$pkg"
  done

  echo ""
  echo "=== Removing Omarchy Webapps ==="
  for webapp in "${DEFAULT_WEBAPPS[@]}"; do
    remove_webapp "$webapp"
  done

  echo ""
  echo "✅ Done removing omarchy apps!"
}

main "$@"
