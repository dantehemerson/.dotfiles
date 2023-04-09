## ============= HOMEBREW ===============

# cat with highlight
brew install bat

# Render markdown on the CLI, with pizzazz!
brew install glow


## ============ CONFIGS =======================

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# ================ FINDER ===============

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

