function pvg-dev-help {
  echo -e "description: "
  echo -e "\t start working on your feature."
  echo -e "usage: "
  echo -e "\t pvg-dev a_branch_name"
  echo ""
  echo -e "\t guarantees clean working set based of master"
}

function pvg-dev {
  git checkout master
  git checkout -b $1
  git pull origin master
  echo -e "You're now ready to develop your story."
}

function pvg-update_help {
  echo -e "usage: "
  echo -e "\t pvg-update"
  echo -e "Syncs with repository."
}

function pvg-update {
  git pull origin master
}

function pvg-dev-done-help {
  echo -e "usage: "
  echo -e "\t pvg-dev-done 'message'"
  echo -e "\t message is your commit message"
  echo -e ""
  echo -e "example: "
  echo -e "\t Implemented story 13."
  echo -e "\t Updated FileReaderInterface."
  echo -e "\t Fixed merge conflict."
  echo -e "\t etc....."
}

function pvg-dev-done {
  git commit -am $1
  local BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  git push origin $BRANCH
  git checkout master
  git pull origin master
  git merge $BRANCH
  echo "Fix your (potential) conflicts and then run:"
  echo -e "\t pvg-ready-to-release"
}

function pvg-ready-to-release-help {
  echo -e "usage: "
  echo -e "\t pvg-ready-to-release"
  echo -e "\t pushes your comitted changed to the repository."
}

function pvg-ready-to-release {
  local BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ $BRANCH == "master" ]; then
      git commit -am 'Fixed merge conflict' # Will not create commit if clean working set
      git push origin master
  else
    echo -e "Cannot release from branch $($CURRENT_BRANCH)."
    echo -e "Can only release from master branch."
    echo -e "Did you forget to run pvg-dev-done?"
  fi
}

function pvg-flow-help {
  echo -e "PVG-FLOW"
  echo -e "Run any command followed by -help for command details."
  echo -e "example: "
  echo -e "\t $ pvg-dev story23"
  echo -e "\t $ pvg-dev-done 'Implemented Story 23'"
  echo -e "\t $ pvg-ready-to-release"
}
