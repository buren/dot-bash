#!/bin/bash

## __SHAMELESS STEELS__ ##
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx

__setup_osx_defaults() {
  echo "Setting up defaults"
  cd $HOME/.buren/dot-bash && sudo ./.osx
  echo "Setup of OSX defaults DONE"
}

__install-osx-mtr() {
  mtr_install_path='/usr/local/Cellar/mtr/0.85/sbin/mtr'
  echo "Downloading mtr"
  brew update && \
  brew install mtr --no-gtk && echo -e "mtr installed \nChowning mtr to root" && \
  sudo chown root:wheel $mtr_install_path && \
  sudo chmod u+s $mtr_install_path && echo "mtr now owned by root" && \
  sudo ln -s $mtr_install_path /usr/local/bin/mtr && echo 'Created symlink to mtr' || \
  echo "Something went wrong"
}
