#!/bin/bash

## __OS X__ ##
source ~/.buren/dot-bash/setup/profile-install/osx-profile-install.bash # Install functions

alias ls='ls -G'
alias la='ls -a'

alias rosetta='arch -x86_64'

# Adds color to osx terminal
export CLICOLOR=1

export EDITOR='code --wait --new-window'
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

alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"

toggle_dark_mode() {
  echo "Toggling dark/light mode"
  osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'
}

restart_input_source_switcher() {
  echo "Killing macOS input source switcher, will reboot in a few seconds"
  sudo killall -9 PAH_Extension TextInputMenuAgent TextInputSwitcher
}

# Overide 'marks' function in .unix-profile (to work consistently across osx/linux)
marks() {
  \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

mov_to_mp4 () {
  local infile="$1"
  local outfile="${2:-${infile%.*}.mp4}"

  ffmpeg -i "$infile" -vcodec h264 -acodec aac -strict -2 "$outfile"
}

mov_to_gif() {
  local infile="$1"
  local outfile="${2:-${infile%.*}.gif}"

  ffmpeg -i $infile -pix_fmt rgb24 -r 10 -f gif - | \
    gifsicle --optimize=3 --delay=10 > $outfile
}

gif_to_mov() {
  local infile="$1"
  local outfile="${2:-${infile%.*}.mov}"

  ffmpeg -i "$infile" \
    -movflags faststart \
    -pix_fmt yuv420p \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
    "$outfile"
}

xls_to_csv() {
  local xlsfile="$1"
  local csvfile="${2:-${xlsfile%.*}.csv}"

  ssconvert "$xlsfile" "$csvfile"
}

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Recursively delete `.DS_Store` files
alias cleanup_osx_files="find . -type f -name '*.DS_Store' -ls -delete"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias lock='afk'
alias screensaver="/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"

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
