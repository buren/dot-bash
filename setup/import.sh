# dot-bash import
function source_dot_bash_files {
  source ~/.dot-bash/unix-profile
  source ~/.dot-bash/git-flow/git_flow.sh
  if [ "$(uname)" == "Darwin" ]; then
      source ~/.dot-bash/osx-profile
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
      source ~/.dot-bash/linux-profile
  fi
}
source_dot_bash_files
# END dot-bash import
