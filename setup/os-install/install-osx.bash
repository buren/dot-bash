#!/bin/bash

__osx_install() {
  __install-homebrew-with-plugins
  __install-common-cli-programs
  __install-nmap
  __install-common-core
}

__install-homebrew-with-plugins() {
   #!/bin/bash
  echo "=== Installing homebrew ==="
  #mkdir homebrew && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C homebrew
  echo "=== Homebrew installed ==="
  echo "\n\n"
  echo "=== Installing Homebrew bash-completion ==="
  brew install bash-completion
  brew tap homebrew/completions
  echo "
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi
" >> $HOME/.bash_profile
  echo "=== Installed Homebrew bash-completion ==="
  echo "=== Installing GNU coreutils (ls, cat etc..) ==="
  brew install coreutils
  echo "=== Installed GNU coreutils ==="
  echo "=== Installing GNU sed ==="
  brew install gnu-sed --default-names # Install the latest version of GNU sed and install it as 'sed' and *not* 'gsed'
  echo "=== Installed GNU sed ==="
  echo "\n\n"
  # ENHANCE OSX quicklook
  echo "=== Enhancing OSX quicklook ==="
  brew update
  brew tap phinze/homebrew-cask
  brew install brew-cask
  brew cask install qlcolorcode
  brew cask install suspicious-package
  brew cask install qlstephen
  brew cask install qlmarkdown
  brew cask install quicklook-json
  brew cask install quicklook-csv
  brew cask install betterzipql
  defaults write com.apple.finder QLEnableTextSelection -bool true && killall Finder
  echo "=== Enhanced OSX quicklook ==="
  echo "\n\n"
}

__install-common-core() {
  # Install GNU core utilities (those that come with OS X are outdated)
  # Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
  brew install coreutils
  # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
  brew install findutils
  # Install Bash 4
  brew install bash
  echo "$(brew --prefix coreutils)/libexec/gnubin" | sudo tee -a /etc/paths >/dev/null
}

__install-common-cli-programs() {
  brew install tree
  brew install wget
  # Install more recent versions of some OS X tools
  echo "Installing new version of vim"
  brew install vim --override-system-vi
  brew tap homebrew/dupes
  echo "Installing a new version of grep"
  brew install homebrew/dupes/grep
}

__install-nmap() {
  echo "Installing Nmap"
  brew install nmap
  echo "Nmap installed"
}

echo "Installing for OSX"
current_folder=$(pwd)
mkdir ~/.buren/dot-bash-temp
cd ~/.buren/dot-bash-temp && __osx_install
cd $current_folder
