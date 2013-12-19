mkdir ~/.buren
mkdir ~/.buren/dot-bash-temp
mkdir ~/.buren/util_scripts
mkdir ~/.buren/bin

sh ~/.buren/dot-bash/install/install-unix.sh
if [ "$(uname)" == "Darwin" ]; then
  sh ~/.buren/dot-bash/install/install-osx.sh
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  sh ~/.buren/dot-bash/install/install-linux.sh
else
  echo "Unknown platform"
  rm -rf ~/.buren/dot-bash-temp
  exit 0
fi

rm -rf ~/.buren/dot-bash-temp

