#!/bin/bash

alias list_functions='compgen -A function'
alias list_aliases='compgen -a'

common_commands() {
  history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
}

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Do sudo a command, or do sudo to the last typed command if no argument given
please() {
  if [[ $# == 0 ]]; then
    sudo $(history -p '!!')
  else
    sudo "$@"
  fi
}

redo_with() {
  if [[ -z "$1" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t $ redo_with <program>"
    echo -e "Run specified program with arguements from previous command."
    echo ""
    echo -e "example:"
    echo -e "\t $ ls <some_file>"
    echo -e "\t $ redo_with <program>"
    echo "will execute: <program> <some_file>"
  else
    $1 $(history -p '!*')
  fi
}
alias rw='redo_with'


alias starwars='traceroute 216.81.59.173'
alias print_ascii='man ascii'

2048-game() {
  if [[ ! -d ~/.buren/bin/sed2048 ]]; then
    echo -e "Could't not find 2048-sed.. Installing..."
    __install-2048-sed
  fi
  bash ~/.buren/bin/sed2048/src/2048.sh
}

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}
alias settitle='titlebar'

function eachdir() {

if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP
eachdir
http://benalman.com/

Usage: eachdir [dirs --] commands

Run one or more commands in one or more dirs.

By default, all subdirs of the current dir will be iterated over, but if --
is specified as an arg, the dirs list will be made up of all args specified
before it. All remaining args are the command(s) to be executed for each dir.

Multiple commands must be specified as a single string argument.

In bash, aliasing like this allows you to specify aliases/functions:
  alias eachdir=". eachdir"

Both of these print the working directory of every subdir of the current dir:
  eachdir pwd
  eachdir * -- pwd

Perform a "git pull" inside all subdirs starting with repo-:
  eachdir repo-* -- git pull

Perform a few git-related commands inside all subdirs starting with repo-:
  eachdir repo-* -- 'git fetch && git merge'

Copyright (c) 2012 "Cowboy" Ben Alman
Licensed under the MIT license.
http://benalman.com/about/license/
HELP
return; fi

if [ ! "$1" ]; then
  echo 'You must specify one or more commands to run.'
  return 1
fi

# For underlining headers.
local h1="$(tput smul)"
local h2="$(tput rmul)"

# Store any dirs passed before -- in an array.
local dashes d
local dirs=()
for d in "$@"; do
  if [[ "$d" == "--" ]]; then
    dashes=1
    shift $(( ${#dirs[@]} + 1 ))
    break
  fi
  dirs=("${dirs[@]}" "$d")
done

# If -- wasn't specified, default to all subdirs of the current dir.
[[ "$dashes" ]] || dirs=(*/)

local nops=()
# Do stuff for each specified dir, in each dir. Non-dirs are ignored.
for d in "${dirs[@]}"; do
  # Skip non-dirs.
  [[ ! -d "$d" ]] && continue
  # If the dir isn't /, strip the trailing /.
  [[ "$d" != "/" ]] && d="${d%/}"
  # Execute the command, grabbing all stdout and stderr.
  output="$( (cd "$d"; eval "$@") 2>&1 )"
  if [[ "$output" ]]; then
    # If the command had output, display a header and that output.
    echo -e "${h1}${d}${h2}\n$output\n"
  else
    # Otherwise push it onto an array for later display.
    nops=("${nops[@]}" "$d")
  fi
done

# List any dirs that had no output.
if [[ ${#nops[@]} > 0 ]]; then
  echo "${h1}no output from${h2}"
  for d in "${nops[@]}"; do echo "$d"; done
fi

} # END eachdir()

# Stopwatch
alias stopwatch='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# JavaScriptCore REPL
jscbin="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"
[ -e "${jscbin}" ] && alias jrb="${jscbin}"
unset jscbin

alias week='date +"%V"'

terminal-dark() {
  if [[ ! -d ~/.buren/terminal-themes/gnome-terminal-colors-solarized ]]; then
    echo "Terminal themes not installed"
    __dot-bash-install-solarized-terminal-colors
  fi
  sh ~/.buren/terminal-themes/gnome-terminal-colors-solarized/set_dark.sh
}
terminal-light() {
  if [[ ! -d ~/.buren/terminal-themes/gnome-terminal-colors-solarized ]]; then
    echo "Terminal themes not installed"
    __dot-bash-install-solarized-terminal-colors
  fi
  sh ~/.buren/terminal-themes/gnome-terminal-colors-solarized/set_light.sh
}

# Simple calculator
function calc() {
  local result=""
  result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
  #                       └─ default (when `--mathlib` is used) is 20
  #
  if [[ "$result" == *.* ]]; then
    # improve the output for decimal numbers
    printf "$result" |
    sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
        -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
        -e 's/0*$//;s/\.$//'   # remove trailing zeros
  else
    printf "$result"
  fi
  printf "\n"
}
