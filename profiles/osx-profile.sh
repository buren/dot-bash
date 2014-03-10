#!/bin/bash

## __OS X__ ##
source ~/.buren/dot-bash/setup/profile-install/osx-profile-install.sh # Install functions

alias ls='ls -G'
alias la='ls -a'

# Adds color to osx terminal
export CLICOLOR=1

# Alias for opening Sublime text 2
alias slime='open -a "Sublime Text 2"'
alias subl='slime'

alias localip='ipconfig getifaddr en0'

# Overide 'marks' function in .unix-profile (to work consistently across osx/linux)
marks() {
  \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

sleepin() {
  if [[ -z "$1" ]]; then
    pmset sleepnow
  else
    echo "Sleeping in $1 minutes"
    sleep $(bc <<< $1*60) && \
    echo "Going to sleep" && \
    pmset sleepnow

  fi
}

## __HOMEBREW__ ##

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion
