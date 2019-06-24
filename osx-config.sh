#!/bin/bash

set -ux

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

### Disable functions
defaults write com.apple.dashboard mcx-disabled -bool true # Dashboard
defaults write com.apple.dock mcx-expose-disabled -bool true # Mission Control

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
