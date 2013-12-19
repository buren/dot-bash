echo "Installing for unix"
$current_folder=$(pwd)
mkdir ~/.buren/dot-bash-temp
cd ~/.buren/dot-bash-temp && __unix_install
cd $current_folder

function __unix_install {
  __install-rvm
}

function __install-rvm {
  \curl -sSL https://get.rvm.io | bash -s stable
}