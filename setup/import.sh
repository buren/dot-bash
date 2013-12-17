# dot-bash import
function source_dot_bash_files {
  source ~/.dot-bash/unix-profile

  if [ -f ~/.git-story/src/git_story.sh ]; then
    source ~/.git-story/src/git_story.sh
  else
    cd ~ && git clone git@github.com:buren/git-story.git && mv git-story .git-story && source ~/.git-story/src/git_story.sh
  fi
  if [ "$(uname)" == "Darwin" ]; then
      source ~/.dot-bash/osx-profile
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
      source ~/.dot-bash/linux-profile
  fi
}
source_dot_bash_files
# END dot-bash import
