###############
# INSTALLS UPON USE #
###############

# Install Ngrok
function __dot-bash-install-ngrok {
  echo "Downloading Ngrok"

  current_folder=$(pwd)
  cd ~/.buren/dot-bash-temp

  if [ "$(uname)" == "Darwin" ]; then
    curl -O https://dl.ngrok.com/darwin_amd64/ngrok.zip
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    curl -O https://dl.ngrok.com/linux_386/ngrok.zip
  else
    echo "Unknown platform, cant install ngrok"
    exit 0
  fi

  unzip ngrok.zip
  rm ngrok.zip

  mkdir ~/.buren/bin
  mv ngrok ~/.buren/bin
  echo "Ngrok downloaded and installed in ~/.buren/bin"
  cd $current_folder
}

function __dot-bash-util-scripts-install {
  echo "Downloading util scripts"
  current_folder=$(pwd)
  cd ~/.buren && git clone https://github.com/buren/util_scripts.git
  cd $current_folder
}


# Terminal colors
function __dot-bash-install-solarized-terminal-colors {
  echo "Installing terminal colors"
  mkdir ~/.buren/terminal-themes
  current_folder=$(pwd)
  cd ~/.buren/terminal-themes && git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
  echo "Terminal colors installed"
  cd $current_folder
}
