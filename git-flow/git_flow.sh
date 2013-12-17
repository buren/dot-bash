################
#     CLI      #
################

function pvg {
  if   [ -z "$1" ] || [ $1 == "help" ]; then
    __pvg-help $2
  else
    __pvg_functions $1 $2
  fi
}

function __pvg_functions {
  if   [ $1 == "dev" ]; then
    __pvg-dev $2
  elif [ $1 == "update" ]; then
    __pvg-update
  elif [ $1 == "checkpoint" ]; then
    __pvg-checkpoint $2
  elif [ $1 == "done" ]; then
    __pvg-ready $2
  elif [ $1 == "release" ]; then
    __pvg-release
  elif [ $1 == "list" ]; then
    __pvg-list-commands
  else
    echo "Unknown command '$1'"
    __pvg-help
  fi
}

function __pvg-help {
  if   [ -z "$1" ]; then
    __pvg-flow-help
  elif [ $1 == "dev" ]; then
    __pvg-dev-help
  elif [ $1 == "update" ]; then
    __pvg-update-help
  elif [ $1 == "checkpoint" ]; then
    __pvg-checkpoint-help
  elif [ $1 == "done" ]; then
    __pvg-ready-help
  elif [ $1 == "release" ]; then
    __pvg-release-help
  else
    echo "Unknown command: '$1'"
    echo ""
    __pvg-flow-help
  fi
}

################
#  FUNCTIONS   #
################

function __pvg-dev {
  if [[ -z "$1" ]]; then
    echo "You must provide a branch name"
    __pvg-dev-help
  else
    git checkout master
    git pull origin master
    git checkout -b $1
    echo -e "You're now ready to implement your feature"
  fi
}

function __pvg-update {
  git pull origin master
}

function __pvg-checkpoint {
  if [[ -z "$1" ]]; then
    echo "You must provide a commit message"
    __pvg-checkpoint-help
  else
    git add --all
    git commit -m $1
  fi
}

function __pvg-ready {
  __pvg-ready-checklist-print
  while true; do
    read -p "Have you answered yes to all of the above? (y\n)" yn
    case $yn in
      [Yy]* ) __pvg-ready-execute $1; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

function __pvg-ready-execute {
  if [[ -z "$1" ]]; then
    echo "You must provide a commit message!"
    __pvg-ready-help
  else
    git add --all
    git commit -m $1
    local BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    git push origin $BRANCH
    git checkout master
    git pull origin master
    git merge $BRANCH
    git commit -am "Fixed merge conflict" # Will not create commit if clean working set
    echo -e "When ready run: "
    echo -e "\t pvg release"
  fi
}

function __pvg-release {
  while true; do
    echo -e ""
    read -p "Are you sure you want to release? (y\n)" yn
    case $yn in
      [Yy]* ) __pvg-release-execute; break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

function __pvg-release-execute {
  local BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ $BRANCH == "master" ]; then
    git push origin master
  else
    echo -e "Cannot release from branch $($CURRENT_BRANCH)."
    echo -e "Can only release from master branch."
    echo -e "Did you forget to run 'pvg done'?"
    echo -e "help: "
    echo -e "\t pvg help"
    echo "or for a specific command"
    echo -e "\t pvg help 'command'"
  fi
}

################
#     HELP     #
################

function __pvg-flow-help {
  echo -e "Run any command followed by 'help' for command details."
  __pvg-list-commands
  echo -e "help: "
  echo -e "\t pvg 'command' help"
  echo -e "usage: "
  echo -e "\t pvg dev story23"
  echo -e "\t pvg done 'Implemented Story 23'"
  echo -e "\t pvg release"
}

function __pvg-list-commands {
  echo ""
  echo "pvg commands: "
  echo -e "\t dev              Start developling a new feature"
  echo -e "\t update           Download changes from remote master branch to local workspace"
  echo -e "\t checkpoint       Commit changes and push branch to remote"
  echo -e "\t done             Commit changes and sync with remote master branch"
  echo -e "\t release          Pushes your committed changes to remote master branch"
}

function __pvg-dev-help {
  echo -e "description: "
  echo -e "\t start implenting your feature."
  echo -e "usage: "
  echo -e "\t pvg dev a_branch_name"
  echo ""
  echo -e "\t guarantees clean workspace from remote master"
}

function __pvg-update-help {
  echo -e "usage: "
  echo -e "\t pvg update"
  echo -e "Download changes from remote master branch to local workspace"
  echo -e "! Can cause merge conflicts"
}

function __pvg-checkpoint-help {
  echo -e "usage: "
  echo -e "\t pvg checkpoint 'Commit message'"
  echo -e "Commit changes and push branch to remote"
}

function __pvg-ready-help {
  echo -e "usage: "
  echo -e "\t pvg done 'Commit message'"
  echo -e "commit message example: "
  echo -e "\t 'Implemented story 13."
  echo -e "\t Updated FileReaderInterface."
  echo -e "\t Fixed merge conflict."
  echo -e "\t etc.....'"
  echo -e "note: "
  echo -e "\t ! Can cause merge conflicts"
}

function __pvg-ready-checklist-print {
  echo "Checklist:"
  echo -e "\t 1. Have you written tests?"
  echo -e "\t 2. Do all tests pass?"
  echo -e "\t 3. Have you refactored your code?"
  echo -e "\t 4. Are you ready for possible merge conflicts?"
  echo ""
}

function __pvg-release-help {
  echo -e "usage: "
  echo -e "\t pvg release"
  echo -e "pushes your committed changes to the repository."
}
