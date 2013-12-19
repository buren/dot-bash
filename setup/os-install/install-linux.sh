echo "Installing Dot bash Linux"
cd ~/.buren/dot-bash-temp && __dot-bash-linux-install

function __dot-bash-linux-install {
  echo "Installing dot-bash Linux dependencies"
  __install-nmap
}

function __install-nmap {
  echo "Installing Nmap"
  sudo apt-get install nmap
  echo "Nmap installed"
}