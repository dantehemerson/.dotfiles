#!/bin/bash

echo "================== IMPORTING DOTFILES ================="


if [[ "$(uname)" == "Darwin" ]]; then
  # Macos Backups

  # Terminal preferences
  cp ~/.dotfiles/macos/preferences/com.apple.Terminal.plist ~/Library/Preferences/
  plutil -convert binary1 ~/Library/Preferences/com.apple.Terminal.plist
  killall Terminal
fi

echo "============== IMPORTING DOTFILES COMPLETE =============="