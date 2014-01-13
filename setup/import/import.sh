source ~/.buren/dot-bash/setup/config.sh
source ~/.buren/dot-bash/profiles/unix-profile.sh
source ~/.buren/dot-bash/profiles/bash-prompt.sh
source ~/.buren/dot-bash/utils/cli.sh

if [[ ! -d ~/.git-story/ ]]; then
  curl https://raw2.github.com/buren/git-story/master/setup/install.sh | bash
fi

if [[ ! -d ~/.buren/util_scripts/ ]]; then
  cd ~/.buren && git clone https://github.com/buren/util_scripts.git
fi

if [[ "$(uname)" == "Darwin" ]]; then
  source ~/.buren/dot-bash/profiles/osx-profile.sh
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
  source ~/.buren/dot-bash/profiles/linux-profile.sh
fi
