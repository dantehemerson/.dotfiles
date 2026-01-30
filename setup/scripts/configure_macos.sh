#!/bin/bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

## ============= GENERAL UI/UX ===============

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Always show scrollbars when scrolling
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

## ========== TRACKPAD, MOUSE, KEYBOARD  ===========

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 12

## ================ FINDER ===============

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Aidrop: Use ethernet
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

## ================ DOCK ===============

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

## ================ DISKS ======================

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

## ================= SPOTLIGHT ===============

# Spotlight search categories (Commented: Spotlight replaced by Raycast)
# defaults write com.apple.spotlight orderedItems -array \
#   '{"enabled" = 1;"name" = "APPLICATIONS";}' \
#   '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
#   '{"enabled" = 0;"name" = "DIRECTORIES";}' \
#   '{"enabled" = 1;"name" = "PDF";}' \
#   '{"enabled" = 0;"name" = "FONTS";}' \
#   '{"enabled" = 0;"name" = "DOCUMENTS";}' \
#   '{"enabled" = 0;"name" = "MESSAGES";}' \
#   '{"enabled" = 0;"name" = "CONTACT";}' \
#   '{"enabled" = 0;"name" = "EVENT_TODO";}' \
#   '{"enabled" = 0;"name" = "IMAGES";}' \
#   '{"enabled" = 0;"name" = "BOOKMARKS";}' \
#   '{"enabled" = 0;"name" = "MUSIC";}' \
#   '{"enabled" = 0;"name" = "MOVIES";}' \
#   '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
#   '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
#   '{"enabled" = 0;"name" = "SOURCE";}' \
#   '{"enabled" = 1;"name" = "MENU_DEFINITION";}' \
#   '{"enabled" = 0;"name" = "MENU_OTHER";}' \
#   '{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
#   '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
#   '{"enabled" = 1;"name" = "MENU_WEBSEARCH";}' \
#   '{"enabled" = 1;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# Save screenshots to ~/Pictures/Screenshots folder
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location ~/Pictures/Screenshots
