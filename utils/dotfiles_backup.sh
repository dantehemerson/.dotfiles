#!/bin/sh

echo "================= BACKING UP DOTFILES ================="

# Macos Backups
if [[ "$(uname)" == "Darwin" ]]; then

  # Terminal preferences
  cp ~/Library/Preferences/com.apple.Terminal.plist ~/.dotfiles/macos/preferences/
  plutil -convert xml1 ~/.dotfiles/macos/preferences/com.apple.Terminal.plist

  # Remove not important keys
  plutil -remove 'NSWindow Frame TTWindow' ./macos/preferences/com.apple.Terminal.plist


fi

echo "============== BACKING UP DOTFILES COMPLETE ============="