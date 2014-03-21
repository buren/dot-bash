#!/bin/bash

source ~/.buren/dot-bash/setup/config.sh
source ~/.buren/dot-bash/profiles/unix-profile.sh
source ~/.buren/dot-bash/profiles/bash-prompt.sh
source ~/.buren/dot-bash/utils/cli.sh

PATH=$PATH:$HOME/.buren/dot-bash/bin/
export PATH

# Git auto complete
if [[ ! -f ~/.git-completion.bash ]]; then
  echo "Git auto complete list not found.. Downloading..."
  curl -O https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
  mv ~/git-completion.bash ~/.git-completion.bash
fi
source ~/.git-completion.bash

if [[ ! -d ~/.git-story/ ]]; then
  curl https://raw2.github.com/buren/git-story/master/setup/install | bash
fi

if [[ ! -d ~/.buren/util_scripts/ ]]; then
  cd ~/.buren && git clone https://github.com/buren/util_scripts.git
fi

if [[ "$(uname)" == "Darwin" ]]; then
  source ~/.buren/dot-bash/profiles/osx-profile.sh
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
  source ~/.buren/dot-bash/profiles/linux-profile.sh
fi

