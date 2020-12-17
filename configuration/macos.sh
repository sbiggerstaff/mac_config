#!/usr/bin/env zsh

# ~/.macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
echo "======= Beginning Script ======="
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `macos.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
echo "======= Setting computer names ======="
# Set computer name (as done via System Preferences → Sharing)
echo "Enter desired computer alias:"
read computer_name
sudo scutil --set ComputerName $computer_name
sudo scutil --set HostName $computer_name/Users/stephenbiggerstaff/mac_config/configuration/macos.sh
sudo scutil --set LocalHostName $computer_name
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $computer_name

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Turn on firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Use dark menu bar and dock
defaults write ~/Library/Preferences/.GlobalPreferences.plist AppleInterfaceTheme -string "Dark"
defaults write ~/Library/Preferences/.GlobalPreferences.plist AppleInterfaceStyle -string "Dark"

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################
echo "======= Trackpad, mouse keyboard, bluetooth and input script ======="
# Configure Keyboard shortcuts
sudo cp -rf ~/mac_config/configuration/com.apple.symbolichotkeys.plist ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Control strip
defaults write com.apple.controlstrip.plist MiniCustomized -array \
    "com.apple.system.brightness"\
    "com.apple.system.volume"\
    "com.apple.system.mute"\
    "com.apple.system.screen-lock"

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Enable force touch 
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool false
# Tap to click 
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
# Tap or press with two fingers to right click 
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
# Rotate gesture on trackpad
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true
# Trackpad Pinch to zoom 
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -int 1
# Smart Zoom
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
# Swipe between apps with 3 fingers
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
# Notifications Gesture
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
# Mission control 3 finger up
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
# Expose Gesture 
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
# Two finger swipe to switch pages
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
# Launchpad gesture
defaults write com.apple.dock showLaunchpadGestureEnabled -bool true
# Desktop gesture
defaults write com.apple.dock showDesktopGestureEnabled -bool true
# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Dock, Dashboard                                                             #
###############################################################################
echo "======= Dock/Dashboard Script ======="
# Enable autohide on Dock
defaults write com.apple.dock autohide -bool true
# Set magnification to true
defaults write com.apple.dock magnification -bool true
# Size 70 icons when highlighted
defaults write com.apple.dock largesize -int 70
# Minimize apps to their app icon
defaults write com.apple.dock minimize-to-application -bool true
# Don't show recent apps on dock
defaults write com.apple.dock show-recents -bool false
# Set standard size to 40
defaults write com.apple.dock tilesize -int 40
# Audohide Delay set to 0
defaults write com.apple.dock autohide-delay -float 0
# Show progress indicators
defaults write com.apple.dock show-process-indicators -bool true
# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true
# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true
# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true
# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

###############################################################################
# Language and Locale                                                         #
###############################################################################
echo "======= Language/Locale Script ======="
# Set language and text formats

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Dublin" > /dev/null

# System language set to English, region set to GB
defaults write ~/Library/Preferences/.GlobalPreferences.plist AppleLocale -string "en_GB"

# Select default metrics
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celsius"

###############################################################################
# Screen, Energy Saving, Hot Corners                                          #
###############################################################################
echo "======= Screensaver/Hot corners Script ======="
# Set screensaver idle time to 1 hour
defaults -currentHost write com.apple.screensaver idleTime -int 3600

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

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
# defaults write com.apple.dock wvous-tl-corner -int 2
# defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
# defaults write com.apple.dock wvous-tr-corner -int 4
# defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Finder, Safari, Mac App Store                                               #
###############################################################################
echo "======= Finder, safari and app store Script ======="
# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true
# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true
# Finder: Display as list by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Finder: Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Some spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 1
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Show the ~/Library folder
chflags nohidden ~/Library
# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true
# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false
# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false
# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Auto Expand save dialogue
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Zoom on tapping title bar 
defaults write -g AppleActionOnDoubleClick -string "Maximize"

###############################################################################
# Making directories		                                                  #
###############################################################################
echo "======= Making directories and setting up finder sidebar ======="
mkdir Projects
mkdir Web

echo "running finder sidebar script"
. ~/mac_config/configuration/finder_sidebar.sh
echo "finished finder sidebar script"

###############################################################################
# Configure System Menu Bar                                                   #
###############################################################################
echo "======= System menu bar Script ======="
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Volume.menu" \
	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
	"/System/Library/CoreServices/Menu Extras/Battery.menu"

defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.airplay" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.clock" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.airport" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -bool true

# Show Battery Percentage on the meny bar
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Show date on the menu bar in 24h clock, no flashing, 
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"
defaults write com.apple.menuextra.clockFlashDateSeparators -bool false

# Show battery % 
defaults write com.apple.menuextra.battery ShowPercent -bool true

###############################################################################
# Photos                                                                      #
###############################################################################
echo "======= Photos Script ======="
# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Setup Command line tools for the next tasks                                 #
###############################################################################
echo "======= xcode-select Script ======="
sudo xcode-select --install

###############################################################################
# Gems                                                                        #
###############################################################################
echo "======= Gems Script ======="
sudo gem install cocoapods
sudo gem install cocoapods-deintegrate

###############################################################################
# Zsh                                                                         #
###############################################################################
echo "======= Zsh Script ======="
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# # Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
# rm -rf $HOME/.zshrc
# ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

###############################################################################
# Homebrew, Apps, Utilities, and Shell                                        #
###############################################################################
echo "======= Homebrew/Apps/Utilities/Shell Script ======="
# sudo chown -R $(whoami) /usr/local/share/man/man8

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
cd ~/mac_config/configuration
brew bundle

echo "configuring dock apps"
sudo cp -rf ~/mac_config/configuration/com.apple.dock.plist ~/Library/Preferences/com.apple.dock.plist


# Switch Zsh to the version installed by brew
# sudo sh -c "echo /usr/local/bin/zsh >> /etc/shells"
# chsh -s /usr/local/bin/zsh

# Install latest node via NVM
# nvm install node

###############################################################################
# Configure Visual Studio	                                                  #
###############################################################################

ln -s ~/.dotfiles/VSCode/* ~/Library/Application\ Support/Code/User/
vscode-config.sh
vscode-sourcekit-lsp.sh

###############################################################################
# General Dotfiles			                                                  #
###############################################################################

ln -s ~/mac_config/.dotfiles/.zshrc ~/.zshrc
ln -s ~/mac_config/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/mac_config/.dotfiles/Alfred.alfredpreferences ~/Library/Application\ Support/Alfred/Alfred.alfredpreferences

###############################################################################
# Github + SSH 				                                                  #
###############################################################################

# . ~/mac_config/configuration/githubssh.sh

###############################################################################
# Wrap up 					                                                  #
###############################################################################
echo "Done. Note that some of these changes require a logout/restart to take effect."
