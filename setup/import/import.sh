#!/bin/bash

source ~/.buren/dot-bash/setup/config.sh
source ~/.buren/dot-bash/profiles/unix-profile.sh
source ~/.buren/dot-bash/profiles/aliases-profile.sh
source ~/.buren/dot-bash/profiles/files-profile.sh
source ~/.buren/dot-bash/profiles/code-profile.sh
source ~/.buren/dot-bash/profiles/git-profile.sh
source ~/.buren/dot-bash/profiles/networking-profile.sh
source ~/.buren/dot-bash/profiles/raspberry-profile.sh
source ~/.buren/dot-bash/profiles/terminal-profile.sh
source ~/.buren/dot-bash/profiles/ssh-profile.sh
source ~/.buren/dot-bash/profiles/utils-profile.sh
source ~/.buren/dot-bash/utils/cli.sh

if [[ $SHELL != "/bin/zsh" ]]; then
  source ~/.buren/dot-bash/profiles/bash-prompt.sh
fi

# Add all files in bin/ to PATH
PATH=$PATH:$HOME/.buren/dot-bash/bin
export PATH

# Git auto complete
if [[ ! -f ~/.git-completion.bash ]]; then
  echo "Git auto complete list not found.. Downloading..."
  cd ~ \
  && touch ~/.git-completion.bash \
  && curl -L https://raw.github.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.bash \
  && echo "Done" || echo "Something went wrong downloading git-completion."
fi
source ~/.git-completion.bash

if [[ ! -d ~/.git-story/ ]]; then
  curl https://raw.githubusercontent.com/buren/git-story/master/setup/install | bash
fi

if [[ ! -d ~/.buren/util_scripts/ ]]; then
  cd ~/.buren && git clone https://github.com/buren/util_scripts.git
fi

if [[ "$(uname)" == "Darwin" ]]; then
  source ~/.buren/dot-bash/profiles/osx-profile.sh
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
  source ~/.buren/dot-bash/profiles/linux-profile.sh
fi
