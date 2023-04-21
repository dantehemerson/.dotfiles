#!/bin/sh

echo "================= BACKING UP DOTFILES ================="

# Macos Backups
if [[ "$(uname)" == "Darwin" ]]; then

  # Terminal preferences
  cp ~/Library/Preferences/com.apple.Terminal.plist ~/.dotfiles/macos/preferences/
  plutil -convert xml1 ~/.dotfiles/macos/preferences/com.apple.Terminal.plist

  # Remove not important keys
  keys_to_remove=(
    'NSWindow Frame TTWindow'
    'NSWindow Frame NSNavPanelAutosaveName'
    'NSWindow Frame NSFontPanel'
    'NSWindow Frame NSColorPanel'
    'NSWindow Frame New Command Panel'
    'NSWindow Frame TTWindow Basic'
    'NSWindow Frame TTWindow Grass'
    'NSWindow Frame TTWindow Homebrew'
    'NSWindow Frame TTAppPreferences'
  )

  for key in "${keys_to_remove[@]}"; do
    plutil -remove "$key" ~/.dotfiles/macos/preferences/com.apple.Terminal.plist
  done

fi

echo "============== BACKING UP DOTFILES COMPLETE ============="