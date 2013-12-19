echo "Installing Dot bash OSX"
cd ~/.buren/dot-bash-temp && __osx-install

function __osx-install {
  __install-homebrew-with-plugins
  __install-common-cli-programs
  __install-nmap
}

function __install-homebrew-with-plugins {
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
}

function __install-common-cli-programs {
  brew install tree
  brew install wget
}

function __install-nmap {
  echo "Installing Nmap"
  brew install nmap
  echo "Nmap installed"
}