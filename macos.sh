#!/bin/bash

# Exit on error
set -e

echo "⚙️ Closing System Preferences..."
osascript -e 'tell application "System Preferences" to quit'

echo "⌨️ Configuring Keyboard settings..."
# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set faster keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

echo "🚀 Configuring Dock settings..."
# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

echo "📁 Configuring Finder settings..."
# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

echo "🖥️ Configuring Desktop settings..."
# Show hard drives on desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

echo "🖱️ Configuring Trackpad settings..."
# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Disable "natural" scrolling. Down for down and up for up
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "🔄 Restarting affected applications..."
for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" >/dev/null 2>&1
done

echo "✨ MacOS settings updated successfully. Some changes may require a restart to take effect."
