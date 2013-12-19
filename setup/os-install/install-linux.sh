echo "Installing Dot bash Linux"
current_folder=$(pwd)
cd ~/.buren/dot-bash-temp && __linux-install
cd $current_folder

function __linux-install {
  echo "Installing dot-bash Linux dependencies"
  __install-nmap
}

function __install-nmap {
  echo "Installing Nmap"
  sudo apt-get install nmap
  echo "Nmap installed"
}