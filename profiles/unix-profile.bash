#!/bin/bash

if [[ $SHELL != '/bin/zsh' ]]; then
  # Case-insensitive globbing (used in pathname expansion)
  shopt -s nocaseglob
  # Append to the Bash history file, rather than overwriting it
  shopt -s histappend
  # Autocorrect typos in path names when using `cd`
  shopt -s cdspell
fi


# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi


# Highlight section titles in manual pages
export LESS_TERMCAP_md="${ORANGE}"
# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"
export GREP_COLOR='1;31' # green for matches


# Larger bash history (allow 32^3 entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoredups
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Highlight section titles in manual pages
export LESS_TERMCAP_md="$ORANGE"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

## __DOT_BASH__ ##
source ~/.buren/dot-bash/setup/profile-install/unix-profile-install.bash # Install functions

## __UNIX__ ##
alias resource="source ~/.bash_profile"
# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# List all files colorized in long format
alias l="ls -lF ${colorflag}"
# List all files colorized in long format, including dot files
alias la="ls -laF ${colorflag}"
# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

alias hs='history | grep --color=auto'
alias o='open'
alias c='clear'
alias mv='mv -i' # prompt if duplicate filename
# Colored and paginated directory tree
alias treep='tree -C "$@" | less -R'
# Search running processes
alias tm='ps -ef | grep --color=auto'

alias cpu_cores='nproc'

# Clojure
lein() {
  if [[ ! -f /bin/lein ]]; then
    echo "Lein clojure not installed"
    echo "Installing..."
    __dot-bash-install-lein-clojure
  fi
  /bin/lein "$@"
}

# Translate text with google-translate-cli
translate() {
  if [[ ! -d ~/.buren/bin/google-translate-cli ]];then
    echo "google-translate-cli not found.."
    echo "Init install script"
    sleep 1
    __dot-bash-install-translate-cli
  fi
  if [[ "$1" == "--help" ]] || [[ "$1" == "-help" ]];then
    echo -e "usage:
      $ translate {=en+ro+de+it} \"hola mundo\"
      hello world
      Bună ziua lume
      Hallo Welt
      ciao mondo

      $ translate \"Saluton, mondo\"
      Hello, world"
    return
  fi

  trs "$@"
}
alias translate_to_swedish='translate {=sv}'
alias translate_from_swedish='translate {sv=en}'

## __MISC__ ##

alias resize_to_width='convert -resize' # Resize args to width, keep aspect ratio

cleanup_whiteboard() {
  if [[ $1 == "--help" ]] || [[ $1 == "-help" ]] || [[ $1 == "-h" ]]; then
    echo "Clean up whiteboard picture"
    echo "Usage: cleanup_whiteboard <input-image> <output-image>"
    return
  fi
  convert $1 -morphology Convolve DoG:15,100,0 -negate -normalize -blur 0x1 -channel RBG -level 60%,91%,0.1 $2
}

random_password() {
  openssl rand -base64 ${1:-12}
}

ricecake() {
  local video='https://youtu.be/uYHAR8Xzsyo'
  if [ "$(uname)" == "Darwin" ]; then
    open $video
  else
    xdg-open $video
  fi
}
