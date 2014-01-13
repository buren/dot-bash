## __SHAMELESS STEELS__ ##
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx

__setup_osx_defaults() {
  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "

  # Menu bar: hide the Time Machine, Volume, User, and Bluetooth icons
  defaults write ~/Library/Preferences/ByHost/com.apple.systemuiserver.* dontAutoLoad -array \
          "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
          "/System/Library/CoreServices/Menu Extras/Volume.menu" \
          "/System/Library/CoreServices/Menu Extras/User.menu" \
          "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

  # Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Disable the “Are you sure you want to open this application?” dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Disable Notification Center and remove the menu bar icon
  launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

  # Disable the sudden motion sensor as it’s not useful for SSDs
  sudo pmset -a sms 0

  # Enable full keyboard access for all controls
  # (e.g. enable Tab in modal dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  # Automatically illuminate built-in MacBook keyboard in low light
  defaults write com.apple.BezelServices kDim -bool true
  # Turn off keyboard illumination when computer is not used for 5 minutes
  defaults write com.apple.BezelServices kDimTime -int 300

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  # Finder: allow text selection in Quick Look
  defaults write com.apple.finder QLEnableTextSelection -bool true

  # When performing a search, search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # Automatically open a new Finder window when a volume is mounted
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

  # Avoid creating .DS_Store files on network volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  # Disable automatic spell checking
  defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"
}
