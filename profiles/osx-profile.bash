#!/bin/bash

## __OS X__ ##
source ~/.buren/dot-bash/setup/profile-install/osx-profile-install.bash # Install functions

alias ls='ls -G'
alias la='ls -a'

# Adds color to osx terminal
export CLICOLOR=1

export EDITOR='atom -nw'
alias e='$EDITOR'

# Alias for opening Sublime text 3
alias slime='open -a "Sublime Text"'
alias subl='slime'

alias chrome='open -a "Google Chrome"'
alias google-chrome='chrome'

alias chrome-canary='open -a "Google Chrome Canary"'
alias google-chrome-canary='chrome-canary'

alias developer_chrome='open -a "Google Chrome" --args --allow-file-access-from-files'
alias dev_chrome='developer_chrome'

alias localip='ipconfig getifaddr en0'

# Launch quicklook from termninal
alias ql='qlmanage -p 2> /dev/null'
alias quicklook='ql'

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"

# Overide 'marks' function in .unix-profile (to work consistently across osx/linux)
marks() {
  \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

mov_to_gif() {
  infile="$1"
  outfile="$2"

  ffmpeg -i $infile -pix_fmt rgb24 -r 10 -f gif - | \
    gifsicle --optimize=3 --delay=10 > $outfile
}

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Recursively delete `.DS_Store` files
alias cleanup_osx_files="find . -type f -name '*.DS_Store' -ls -delete"

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

keepalive() {
  if [[ -z "$1" ]]; then
    echo 'Missing argument: <hours>'
  else
    local min_secs=$(bc <<< $1*60*60)
    echo "Keeping alive $1 hours"
    caffeinate -t $min_secs &
  fi
}


## __HOMEBREW__ ##
if [[ $SHELL != "/bin/zsh" ]]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi

  # If possible, add tab completion for many more commands
  [ -f /etc/bash_completion ] && source /etc/bash_completion
fi

## __PDF__ ##

pdf_merge() {
  local output_file=$1
  echo "Merging all PDFs to: $output_file"
  shift
  "/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" -o $output_file "$@"
}
