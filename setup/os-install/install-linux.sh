echo "Installing Dot bash Linux"
cd ~/.buren/dot-bash-temp && __linux-install

function __linux-install {
  echo "Installing dot-bash Linux dependencies"
  __install-nmap
}

function __install-nmap {
  echo "Installing Nmap"
  sudo apt-get install nmap
  echo "Nmap installed"
}