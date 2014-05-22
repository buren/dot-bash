#!/bin/bash

###############
# INSTALLS UPON USE #
###############

# Install Ngrok
__dot-bash-install-ngrok() {
  echo "Downloading Ngrok"

  current_folder=$(pwd)
  mkdir ~/.buren/dot-bash-temp
  cd ~/.buren/dot-bash-temp

  if [ "$(uname)" == "Darwin" ]; then
    echo "Downloading ngrok for OSX"
    curl -O https://dl.ngrok.com/darwin_amd64/ngrok.zip
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [[ "$(expr substr $(uname -m) 1 3)" == "arm" ]]; then
      echo "Downloading ngrok for ARM proccessor"
      curl -O https://dl.ngrok.com/linux_arm/ngrok.zip
    else
      echo "Downloading ngrok for i386"
      curl -O https://dl.ngrok.com/linux_386/ngrok.zip
    fi
  else
    echo "Unknown platform, cant install ngrok"
    exit 0
  fi

  unzip ngrok.zip
  rm ngrok.zip

  [[ ! -d ~/.buren/bin ]] && mkdir -p ~/.buren/bin
  mv ngrok ~/.buren/bin/
  echo "Ngrok downloaded and installed in ~/.buren/bin"
  cd $current_folder
}

__dot-bash-install-betty() {
  echo "Downloading betty"
  current_folder=$(pwd)
  mkdir ~/.buren/bin
  cd ~/.buren/bin \
  && git clone --depth=1 https://github.com/pickhardt/betty \
  && echo 'Installed betty in ~/.buren/bin' \
  || echo 'Something went wrong installing betty, check the output.'
  cd $current_folder
}

__dot-bash-util-scripts-install() {
  echo "Downloading util scripts"
  current_folder=$(pwd)
  cd ~/.buren && git clone --depth=1 https://github.com/buren/util_scripts.git
  cd $current_folder
}

__dot-bash-install-node-file-server() {
  echo "Installing node"
  current_folder=$(pwd)
  if [[ "$(uname)" == "Darwin" ]]; then
    brew install node
  elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    echo "Will install node from apt-get beware that the version might be outdated."
    echo "Continuing in 2 seconds..."
    sleep 2
    sudo apt-get install nodejs npm node-semver
  fi

  cd ~/.buren/bin/
  git clone --depth=1 https://github.com/buren/simple-file-server
  npm install optimist
  npm install http
  npm install express
  npm install winston
  npm install lodash
  cd $current_folder
  echo "Successfully installed node and downloaded simple-file-server"
}


# Terminal colors
__dot-bash-install-solarized-terminal-colors() {
  echo "Installing terminal colors"
  mkdir ~/.buren/terminal-themes
  current_folder=$(pwd)
  cd ~/.buren/terminal-themes && git clone --depth=1 https://github.com/sigurdga/gnome-terminal-colors-solarized.git
  echo "Terminal colors installed"
  cd $current_folder
}

__dot-bash-install-lein-clojure() {
  echo "Downloading lein clojure script"
  sudo wget -O /bin/lein https://raw.github.com/technomancy/leiningen/stable/bin/lein
  sudo chmod a+x /bin/lein
  /bin/lein "$@"
  echo "Installed lein clojure script"
}


__dot-bash-install-translate-cli() {
  [[ ! -d ~/.buren/bin ]] && mkdir -p ~/.buren/bin/
  cd ~/.buren/bin/ && \
  echo "Downloading google-translate-cli" && \
  git clone git://github.com/soimort/google-translate-cli.git && \
  cd  ~/.buren/bin/google-translate-cli/ && \
  echo "Installing google-translate-cli" && \
  make install
}

__dot-bash-install-cast-localvideo() {
  current_folder=$(pwd)
  echo "Installing cast-localvideo"
  [[ ! -d ~/.buren/bin ]] && mkdir -p ~/.buren/bin/
  cd ~/.buren/bin/ \
  && git clone --depth=1 https://github.com/mustafaakin/cast-localvideo.git \
  && cd ~/.buren/bin/cast-localvideo \
  && npm install
  echo "Installed cast-localvideo"
  cd $current_folder
}

__install-2048-sed() {
  current_folder=$(pwd)
  echo "Installing 2048-sed"
  [[ ! -d ~/.buren/bin ]] && mkdir -p ~/.buren/bin
  cd ~/.buren/bin/ \
  && git clone --depth=1 https://github.com/themattrix/sed2048.git \
  || echo "Something went wrong"
  echo "Installed"
  cd $current_folder
}

__dot-bash-install-git-draw() {
  current_folder=$(pwd)
  echo 'Installing git-draw'
  [[ ! -d ~/.buren/bin ]] && mkdir -p ~/.buren/bin
  cd ~/.buren/bin/ \
  && git clone --depth=1 https://github.com/buren/git-draw.git \
  || echo "Something went wrong"
  echo "git-draw installed"
  cd $current_folder
}
