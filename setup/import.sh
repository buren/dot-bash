source ~/.dot-bash/unix-profile
if [ "$(uname)" == "Darwin" ]; then
    source ~/.dot-bash/osx-profile
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    source ~/.dot-bash/linux-profile
fi
