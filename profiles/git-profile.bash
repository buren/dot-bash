#!/bin/bash

## __GIT__ ##
git config --global help.autocorrect 20 # Auto correct misspellings, after a 2 sec delay
git config --global color.ui auto       # Use colors by default
git config --global merge.stat true     # Always show merge stats


# If hub is installed alias it to git
#if type hub > /dev/null; then
#  alias git='hub'
#fi
alias gut='git'
alias gdiff='git diff'
alias gdiffstaged='git diff --staged'
alias gitmerged='git branch --merged'
alias gmerged='gitmerged'
alias gunmerged='git branch --no-merged'
alias gitnomerged='gunmerged'
alias gnomerged='gunmerged'
alias gshow='git show '
alias gprettylog='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
alias glog='gprettylog'
alias gadd='git add .'
alias gcheck='git checkout'
alias gbranch='git branch'
# Finds
alias gfindreg='git rev-list --all | xargs git grep'  # Find in history regex
alias gfind='git rev-list --all | xargs git grep -F'  # Find in history string search

gcommit() {
  git add --all
  git commit -m "$1"
}

gpush() {
  if [ -z "$1" ]; then
    echo "usage:"
    echo "'\t gpush <branch> <commit_message>"
    return
  elif [ -z "$2" ]; then
    git push origin $1
  else
    git add --all
    git commit -m "$2"
    git push origin $1
  fi
}

gitfuckit() {
  gpush ${1-master} ${2-update}
}

# TODO: cd to the cloned directory
qclone()  {
  clone_url=$1
  git clone --depth=1 $clone_url
}

alias github_open="open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"

# open all changed files (that still actually exist) in the editor
function ged() {
  local files=()
  for f in $(git diff --name-only "$@"); do
    [[ -e "$f" ]] && files=("${files[@]}" "$f")
  done
  local n=${#files[@]}
  echo "Opening $n $([[ "$@" ]] || echo "modified ")file$([[ $n != 1 ]] && \
    echo s)${@:+ modified in }$@"
  atom "${files[@]}"
}


# GitHub URL for current repo.
function gurl() {
  local remotename="${@:-origin}"
  local remote="$(git remote -v | awk '/^'"$remotename"'.*\(push\)$/ {print $2}')"
  [[ "$remote" ]] || return
  local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
  echo "https://github.com/$user_repo"
}


# open last commit in GitHub, in the browser.
function gfu() {
  local n="${@:-1}"
  n=$((n-1))
  open $(git log -n 1 --skip=$n --pretty=oneline | awk "{printf \"$(gurl)/commit/%s\", substr(\$1,1,7)}")
}

git-draw() {
  if [[ ! -d ~/.buren/bin/git-draw ]]; then
    echo 'git-draw not found.'
    __dot-bash-install-git-draw
  fi
  open_with=${1:-open}
  ~/.buren/bin/git-draw/git-draw-watch ~/.buren/bin/git-draw/git-draw \
  --hide-reflogs \
  --hide-legend \
  --hide-blobcontent \
  --display-cmd $open_with
}
