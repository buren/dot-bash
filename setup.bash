#!/bin/bash

__dot-bash-symlink() {
  local file=$1
  if [[ -f ~/$file ]]; then
    echo "[WARNING] $file already existing skipping symlink for $file"
  else
    ln -s ~/.buren/dot-bash/$file $HOME/$file && \
      echo "Symlinked $file" || \
      echo "[ERROR] Failed to symlink $file"
  fi
}

__dot-bash-inject-to-profile() {
  if [[ -f ~/.bash_profile ]]; then
    echo "Injecting import: bash_profile"
    cat ~/.buren/dot-bash/setup/import/import_to_bash_profile >> ~/.bash_profile
    source ~/.bash_profile
  elif [[ -f ~/.bashrc ]]; then
    echo "Injecting import: bashrc"
    cat ~/.buren/dot-bash/setup/import/import_to_bash_profile >> ~/.bashrc
    source ~/.bashrc
  elif [[ -f ~/.zshrc ]]; then
    echo "Injecting import: zshrc"
    cat ~/.buren/dot-bash/setup/import/import_to_bash_profile >> ~/.zshrc
    source ~/.zshrc
  else
    echo "[ERROR] Neither .bash_profile, .bashrc or .zshrc found."
    echo "However the script has been loaded and will be available in the current shell session."
    echo ""
    echo -e "To install add the below line to your bash profile."
    echo -e "\t cat ~/.buren/dot-bash/setup/import/import_to_bash_profile >> ~/.your_profile"
  fi
  __dot-bash-symlink '.inputrc'
  __dot-bash-symlink '.curlrc'
  __dot-bash-symlink '.gemrc'
  __dot-bash-symlink '.irbrc'
  __dot-bash-symlink '.gitconfig'
  __dot-bash-symlink '.gitconfig_global'
}

mkdir ~/.buren
CURRENT_FOLDER=$(pwd) && \
cd ~/.buren && \
git clone https://github.com/buren/dot-bash.git && \
__dot-bash-inject-to-profile && \
cd $CURRENT_FOLDER
