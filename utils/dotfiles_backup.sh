#!/bin/sh

echo "================= BACKING UP DOTFILES ================="

# if macos
if [[ "$(uname)" == "Darwin" ]]; then
  # Backup Terminal preferences
  cp ~/Library/Preferences/com.apple.Terminal.plist ~/.dotfiles/macos/preferences/
  plutil -convert xml1 ~/.dotfiles/macos/preferences/com.apple.Terminal.plist
fi

echo "============== BACKING UP DOTFILES COMPLETE ============="