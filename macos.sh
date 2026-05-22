#!/usr/bin/env bash
# macOS system defaults. Run via install.sh.
#
# To find a default key: cd /tmp && defaults read > before, make change,
# defaults read > after, then diff before after.
#
# Reference: https://macos-defaults.com
#            https://github.com/herrbischoff/awesome-macos-command-line

# Warn if not running as root (some commands require it)
if [[ $EUID -ne 0 ]]; then
  RUN_AS_ROOT=false
  printf "Note: some settings require sudo and will be skipped. Run with sudo to apply all settings.\n\n"
else
  RUN_AS_ROOT=true
  # Keep sudo timestamp alive for the duration of the script
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

# Close System Preferences to prevent it overriding changes
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Restart automatically if the computer freezes
if [[ "$RUN_AS_ROOT" = true ]]; then
  systemsetup -setrestartfreeze on
fi

# Disable smart quotes and dashes (annoying when typing code)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Enable automatic software update checks
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

###############################################################################
# Trackpad, mouse, keyboard                                                   #
###############################################################################

# Keyboard: fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Trackpad: enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
if [[ "$RUN_AS_ROOT" = true ]]; then
  sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
fi

###############################################################################
# Screen                                                                      #
###############################################################################

# Save screenshots to Downloads folder in PNG format, without shadow
defaults write com.apple.screencapture location -string "${HOME}/Downloads"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# New Finder windows open to home folder
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show all filename extensions, status bar, path bar, posix path in title
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Use column view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

###############################################################################
# Dock                                                                        #
###############################################################################

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 48

###############################################################################
# iTerm2                                                                      #
###############################################################################

# Set default font to SauceCodeProNerdFont
plutil -replace "New Bookmarks.0.Normal Font" -string 'SauceCodeProNerdFont---Regular 14' \
  ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null || true

# Set Option key to send Esc-meta (needed for alt keybindings in CLI)
plutil -replace "New Bookmarks.0.Option Key Sends" -integer 2 \
  ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null || true

###############################################################################
# Kill/restart affected applications                                          #
###############################################################################

if [[ ! ($* == *--no-restart*) ]]; then
  for app in "cfprefsd" "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" &>/dev/null || true
  done
fi

printf "\nDone. Log out and back in for all settings to take effect.\n"
