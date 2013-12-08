#!/bin/bash
echo "=== Installing homebrew ==="
mkdir homebrew && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C homebrew
echo "=== Homebrew installed ==="
echo "\n\n"
echo "=== Installing Homebrew bash-completion ==="
brew install bash-completion
echo "=== Installed Homebrew bash-completion ==="
echo "\n\n"
# ENHANCE OSX quicklook
echo "=== Enhancing OSX quicklook ==="
brew update
brew tap phinze/homebrew-cask
brew install brew-cask
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install quicklook-csv
brew cask install betterzipql
defaults write com.apple.finder QLEnableTextSelection -bool true && killall Finder
echo "=== Enhanced OSX quicklook ==="
echo "\n\n"
