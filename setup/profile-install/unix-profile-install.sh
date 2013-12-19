###############
# INSTALL UPON USE  #
###############

# Install Ngrok
function __dot-bash-install-ngrok {
  echo "Downloading Ngrok"

  if [ "$(uname)" == "Darwin" ]; then
    curl -O https://dl.ngrok.com/darwin_amd64/ngrok.zip
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    curl -O https://dl.ngrok.com/linux_386/ngrok.zip
  else
    echo "Unknown platform, cant install ngrok"
    exit 0
  fi

  unzip ngrok.zip

  mkdir ~/.buren/bin
  mv ngrok ~/.buren/bin
  echo "Ngrok downloaded and installed in ~/.buren/bin"
}


# Terminal colors
function __dot-bash-install-solarized-terminal-colors {
  mkdir ~/.buren/terminal-themes && ~/.buren/terminal-themes && git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
}