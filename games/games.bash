alias wordle="sh ~/.buren/dot-bash/games/wordle.sh"

game-2048() {
 if [[ ! -d ~/.buren/bin/term2048 ]]; then
    echo -e "Could not find term2048.. Installing..."
    __install-term2048
  fi
  term2048
}
