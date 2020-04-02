#!/bin/bash

set -uex

if [ "$(uname)" != 'Darwin' ]; then
  echo "Aborted: This script for macOS, your platform seems not."
  exit 1
fi

### Make sure closing all "System Preferences" panes
osascript -e 'tell application "System Preferences" to quit'

### Visible directories
chflags nohidden ~/Library
sudo chflags nohidden /Volumes

### Keyboard
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 12

### Trackpad
defaults write -g com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 2
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

### General
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles YES
defaults write NSGlobalDomain com.apple.springing.delay -float 0
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSWindowResizeTime -float 0.005
defaults write com.apple.CrashReporter DialogType -string "none"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

### Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true # Disabled

### Dock
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock largesize -int 57
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false # Disable: Automatically rearrange Spaces
defaults write com.apple.dock mcx-expose-disabled -bool true # Disable: Mission Control

### Hot Corner
defaults write com.apple.dock wvous-bl-corner -int 10 # bl=bottom+left, 10=Put display to sleep
defaults write com.apple.dock wvous-bl-modifier -int 524288 # 524288=Option

### Finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true # Title bar shows full path
defaults write com.apple.finder AnimateWindowZoom -bool false
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # Search current directory by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder WarnOnEmptyTrash -bool false

### Safari
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
defaults write com.apple.Safari ShowStatusBar -bool true

### diff-highlight on PATH
sudo ln -sf /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin/

### CotEditor on CLI
sudo ln -sf /Applications/CotEditor.app/Contents/SharedSupport/bin/cot /usr/local/bin/

### Fix Ricty's backquote
./scripts/fix-ricty-backquote.sh >/dev/null
