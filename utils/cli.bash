#!/bin/bash

buren() {
  if  [[ -z "$1" ]]; then
    __buren-help
  else
    __buren_functions "$@"
  fi
}

__buren_functions() {
  if   [[ "$1" == "self-destruct" ]]; then
    __b_self_destruct
  elif [[ "$1" == "update" ]]; then
    __b_update "$2"
  elif [[ "$1" == "setup" ]]; then
    __b_setup "$2"
  elif [[ "$1" == "edit" ]]; then
    __b_edit "$2"
  elif [[ "$1" == "extend" ]]; then
    __b_extend
  elif [[ "$1" == "stat" ]]; then
    __b_stat "$2" "$3"
  elif [[ "$1" == "list" ]];then
    if [[ "$2" == "alias" ]] || [[ "$2" == "aliases" ]]; then
      __b_list_aliases
    elif [[ "$2" == "function" ]] || [[ "$2" == "functions" ]]; then
      __b_list_functions
    else
      __b_list_aliases
      __b_list_functions
    fi
  else
    echo "Unknown command '$1'"
    __buren-help
  fi
}


###############
#        FUNCTIONS        #
###############
__buren-stat-help() {
  echo "available:"
  echo -e "'\t commands 2             prints 2 most popular commands (default: 12)"
}

__b_stat() {
  if [[ "$1" == "commands" ]]; then
    __b_popular_commands $2
  else
    echo "Unknown command '$1'"
    __buren-stat-help
  fi
}

__b_popular_commands() {
  cut -f1 -d" " ~/.bash_history | sort | uniq -c | sort -nr | head -${1-12}
}

__b_list_functions() {
  grep -rh '()' ~/.buren/dot-bash
}

__b_list_aliases() {
  grep -rh 'alias ' ~/.buren/dot-bash
}

__b_self_destruct() {
  if [[ "$1" == "--help" || "$1" == "-help " ]]; then
    echo "usage:"
    echo -e "\t buren self-destruct"
    echo "removes the script entirely (rm -rf ~/.buren)"
  else
    while true; do
      read -p "Are you sure? (y\n)" yn
      case $yn in
        [Yy]* ) __b_self_destruct_execute "$1"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
      esac
    done
  fi
}

__b_self_destruct_execute() {
  rm -rf ~/.buren
}

__b_update() {
  if   [[ "$1" == "--help" || "$1" == "-help" ]]; then
    echo "usage:"
    echo -e "\t buren update <pkg>"
    echo "no argument will update all packages"
    echo "available packages: git-story, dot-bash, util-scripts"
  else
    local CURRENT_FOLDER=$(pwd)
    if [ "$1" == "git-story" ]; then
      __b_update_git_story
    elif [ "$1" == "util-scripts" ]; then
      __b_update_util_scripts
    elif [ "$1" == "dot-bash" ];then
      __b_update_dot_bash
    elif [ -z "$1" ]; then
      __b_update_dot_bash
      __b_update_util_scripts
      __b_update_git_story
    fi
    source ~/.bash_profile
    cd $CURRENT_FOLDER
  fi
}

__b_update_dot_bash() {
  echo "Updating dot-bash"
  cd ~/.buren/dot-bash && git pull origin master
}

__b_update_git_story() {
  echo "Updating git-story"
  cd ~/.git-story && git pull origin master
}

__b_update_util_scripts() {
    echo "Updating util_scripts"
    cd ~/.buren/util_scripts && git pull origin master
}

__b_edit() {
  if [[ "$1" == "--help" || "$1" == "-help" ]]; then
    echo "Usage:"
    echo -e "\t buren edit <package>"
    echo "Available packages:"
    echo -e "\t dot-bash (alias: bash), git-story (alias: git), util_scripts (alias: scripts)"
    echo "Default:  dot-bash"
  else
    if  [[ -z "$1" ]]; then
      $($B_EDITOR ~/.buren/dot-bash)
    else
      if [[ "$1" == "dot-bash" ]] || [ "$1" == "bash" ]; then
        $($B_EDITOR ~/.buren/dot-bash/)
      elif [[ $1 == "git-story" ]] || [[ $1 == "git" ]]; then
        $($B_EDITOR ~/.git-story/)
      elif [[ $1 == "util_scripts" ]] || [[ $1 == "scripts" ]]; then
        $($B_EDITOR ~/.buren/util_scripts/)
      else
        echo "Unkown package: $1"
        echo "Available packages:"
        echo -e "\t dot-bash (alias: bash), git-story (alias: git), util_scripts (alias: scripts)"
      fi
    fi
  fi
}

__b_extend() {
  if [[ ! -z $1 ]];then
    echo -e "extend doesn't take any arguments."
    echo "Ignoring all arguments"
  fi
  cd ~/.buren/dot-bash/
    __b_edit "dot-bash"
}


__b_setup() {
  if [[ "$1" == "--help" || "$1" == "-help" ]]; then
    echo "usage:"
    echo -e "\t buren setup <arg>"
    echo "available args: os, defaults"
    echo ""
    echo "Command explaination:"
    echo -e "\t os            Installs packages for current platform"
    echo -e "\t defaults      Sets default values (startup options etc) for current platform"
  elif [ "$1" == "os" ]; then
    __b_setup_os
  elif [[ $1 == "defaults" ]]; then
    __b_setup_defaults
  else
    echo "Unknown option '$1'"
    __b_setup --help
  fi
}

__b_setup_os() {
  if [[ "$(uname)" == "Darwin" ]]; then
    sh ~/.buren/setup/os-install/install-osx.bash
  elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    sh ~/.buren/setup/os-install/install-linux.bash
  fi
}

__b_setup_defaults() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "Setting up defaults for OSX"
    __setup_osx_defaults
  elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    echo "No defaults configured for Linux"
  fi
}


###############
#             HELP            #
###############

__buren-help() {
  echo "usage: "
  echo -e "\t buren update <pkg>"
  echo -e "\t buren self-destruct"
  echo "help:"
  echo -e "\t buren <command> -help"
}
