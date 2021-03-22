#!/bin/sh

###################################################################################
# STSTEM
###################################################################################

echo "Setting sane defaults for System... \c"

# Language: Turn-off auto correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# AirDrop: Use AirDrop over every interface.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# System: Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# System: Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# System: Increase window resize speed for native mac applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.1

# System: Disable the “Are you sure you want to open this application?” dialog
# ? defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write com.apple.LaunchServices LSQuarantine -bool NO

# System: Disable opening and closing window animations defaults
## write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

echo "Done"

###################################################################################
# TRACKPAD
###################################################################################

echo "Setting sane defaults for Trackpad... \c"

# Trackpad: Enable tap to click for this user and for the login screen
# ? defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# ? defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# ? defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Done"

###################################################################################
# KEYBOARD
###################################################################################

echo "Setting sane defaults for Keyboard... \c"

# Keyboard: Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Keyboard: Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Keyboard: Allow press and hold for all keys
## defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Done"

###################################################################################
# DISPLAY
###################################################################################

echo "Setting sane defaults for Display... \c"

# Display: Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo "Done"

###################################################################################
# TRASH
###################################################################################

echo "Setting sane defaults for Trash... \c"

# Trash: Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Trash: Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

echo "Done"

###################################################################################
# DOCK
###################################################################################

echo "Setting sane defaults for Dock... \c"

# Dock: Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Dock: Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -int 0

# Dock: Speed up Dock show animation
defaults write com.apple.dock autohide-time-modifier -float 0.4

# Dock: Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Dock: Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Dock: Don’t animate opening applications from the Dock
## defaults write com.apple.dock launchanim -bool false

# Dock: Make dock immutable
## defaults write com.apple.dock contents-immutable -bool true

# Dock: Make Dock icons of hidden applications translucent
# defaults write com.apple.dock showhidden -bool true

echo "Done"

###################################################################################
# MISSION CONTROL & LAUNCHPAD
###################################################################################

echo "Setting sane defaults for Launchpad... \c"

# Launchpad: Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Launchpad: Reset layout
## defaults -currentHost write com.apple.dock ResetLaunchPad -bool true

echo "Done"

###################################################################################
# FINDER
###################################################################################

echo "Setting sane defaults for Finder... \c"

# Finder: Show the ~/Library folder
chflags nohidden ~/Library

# Finder: Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Finder: Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Network: Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Finder: Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder: Show icons for external hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Finder: Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# Finder: Always open everything in Finder's list view. Four-letter codes for view modes: `icnv`, `Nlsv`, `clmv`, `Flwv`
## defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Finder: Show status bar
## defaults write com.apple.finder ShowStatusBar -bool true

# Finder: Show hidden files
## defaults write com.apple.Finder AppleShowAllFiles -bool true

# Finder: Show icons for internal hard drives on desktop
## defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

# Finder: Display full POSIX path as Finder window title
## defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons
## defaults write com.apple.finder QuitMenuItem -bool true

echo "Done"

###################################################################################
# SAFARI
###################################################################################

echo "Setting sane defaults for Safari... \c"

# Safari: Set Safari’s home page to `about:blank` for faster loading
# ? defaults write com.apple.Safari HomePage -string "about:blank"

# Safari: Hide Safari's bookmark bar.
# ? defaults write com.apple.Safari ShowFavoritesBar -bool false

# Safari: Disable auto open safe downloads
# ? defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Safari: Hide Safari’s sidebar in Top Sites
# ? defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Safari: Make Safari’s search banners default to Contains instead of Starts With
# ? defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Set up Safari for development.
# ? defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
# ? defaults write com.apple.Safari IncludeDevelopMenu -bool true
# ? defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# ? defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# ? defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "Done"

###################################################################################
# MAIL
###################################################################################

echo "Setting sane defaults for Mail... \c"

# Mail: Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
# ? defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"

echo "Done"

###################################################################################
# PHOTOS
###################################################################################

echo "Setting sane defaults for Photos... \c"

# Photos: Stop Photos from opening automatically on plugging devices
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

echo "Done"

###################################################################################
# TERMINAL
###################################################################################

echo "Setting sane defaults for Terminal... \c"

# Terminal: Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

echo "Done"

###################################################################################
# TIME MACHINE
###################################################################################

echo "Setting sane defaults for Time Machine... \c"

# Time Machine: Disable local Time Machine backups
## sudo tmutil disablelocal

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "Done"

###################################################################################
# ACTIVITY MONITOR
###################################################################################

echo "Setting sane defaults for Activity Monitor... \c" 

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Visualize CPU usage in the Activity Monitor Dock icon (default: IconType -int 1)
## defaults write com.apple.ActivityMonitor IconType -int 5

echo "Done"

###################################################################################
# APPLY SETTINGS
###################################################################################

echo "Restarting affected apps... \c"

for app in "Activity Monitor" "Dock" "Finder" "Safari" "Mail"; do
	killall "${app}" &>/dev/null
done
echo "Done"

echo "${RED}Note that some of these changes require a logout/restart to take effect.${NC}"
