#!/bin/bash

source ~/.buren/dot-bash/setup/config.bash
source ~/.buren/dot-bash/profiles/unix-profile.bash
source ~/.buren/dot-bash/profiles/aliases-profile.bash
source ~/.buren/dot-bash/profiles/files-profile.bash
source ~/.buren/dot-bash/profiles/code-profile.bash
source ~/.buren/dot-bash/profiles/git-profile.bash
source ~/.buren/dot-bash/profiles/networking-profile.bash
source ~/.buren/dot-bash/profiles/raspberry-profile.bash
source ~/.buren/dot-bash/profiles/terminal-profile.bash
source ~/.buren/dot-bash/profiles/ssh-profile.bash
source ~/.buren/dot-bash/profiles/utils-profile.bash
source ~/.buren/dot-bash/profiles/autocomplete-man-profile.bash
source ~/.buren/dot-bash/utils/cli.bash

if [[ $SHELL != "/bin/zsh" ]]; then
  source ~/.buren/dot-bash/profiles/bash-prompt.bash
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
  source ~/.buren/dot-bash/profiles/osx-profile.bash
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
  source ~/.buren/dot-bash/profiles/linux-profile.bash
fi

echo 'Imported dot-bash by @buren'
