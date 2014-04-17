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


# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoredups
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Highlight section titles in manual pages
export LESS_TERMCAP_md="$ORANGE"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# TODO: Use symlink instead
if [[ -f ~/.inputrc ]]; then
  completion_inserted=$(cat $HOME/.inputrc | grep "completion-ignore-case")
  if [[ -z $completion_inserted ]];then
    echo "completion-ignore-case not set. Inserting to ~/.inputrc"
    echo "set completion-ignore-case On" >> ~/.inputrc
    echo "Inserted completion-ignore-case to ~/.inputrc..."
  fi
else
  echo "No inputrc file found. Creating..."
  cat $HOME/.buren/dot-bash/.inputrc > $HOME/.inputrc
  echo "Inserted completion-ignore-case to ~/.inputrc..."
fi
# TODO: Use symlink instead
if [[ ! -f ~/.curlrc ]];then
  echo "No curlrc found, injecting..."
  cat $HOME/.buren/dot-bash/.curlrc > $HOME/.curlrc
fi

## __DOT_BASH__ ##
source ~/.buren/dot-bash/setup/profile-install/unix-profile-install.sh # Install functions

## __UNIX__ ##

alias resource="source ~/.bash_profile"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

alias rsync='rsync --progress'

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
fi


# Save output of ssh session to log file.
sshlog() {
  \ssh $@ 2>&1 | tee -a $(date +%Y%m%d).log
}

ssh-remember-me() {
  default_key="$HOME/.ssh/id_rsa.pub"
  if [[ -z "$1" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "usage:"
    echo "ssh-remember-me <host> <key>"
    echo "key is optional and defaults to: $default_key"
    return
  fi
  host=$1
  ssh $host mkdir -p .ssh
  cat ${2:-$default_key} | ssh $host 'cat >> .ssh/authorized_keys'
}


## __RASPBERRY__ ##
if [[ $B_HAS_RASPBERRY == true ]]; then
  alias xbmc_start='sudo initctl start xbmc'
  alias xbmc_stop='sudo initctl stop xbmc'
  alias xbmc_restart='xbmc_stop && xbmc_start'

  pi_login() {
    ssh $B_PI_USERNAME@$B_PI_LOGIN "$@"
  }
  pi_printip() {
    echo "$B_PI_LOGIN"
  }
  login_pi() {
    pi_login
  }
  pi_browse() {
    open http://$B_PI_LOGIN:$B_PI_BROWSE_PORT
  }
  pi_torrent() {
    open http://$B_PI_LOGIN:$B_PI_TORRENT_PORT
  }
  pi_remote() {
    open http://$B_PI_LOGIN:$B_PI_REMOTE_PORT
  }
fi

count_size() {
  du -sh $1
}

find_large_files() {
  if [[ -z $1 ]]; then
    folder="."
  else
    folder="$1"
  fi
  find $folder -type f -size +10000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
}

# Counts the number of files in folder
count_files() {
  ls $1 | wc -l
}
alias lc='count_files' # short hand for the above function


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
alias tree='tree -C $* | less -R'
# Search running processes
alias tm='ps -ef | grep --color=auto'

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

# Extract a lot of different archieve formats
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function archive() {
  local tmpFile="${@%/}.tar"
  tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

  size=$(
    stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
    stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
  )

  local cmd=""
  if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
    # the .tar file is smaller than 50 MB and Zopfli is available; use it
    cmd="zopfli"
  else
    if hash pigz 2> /dev/null; then
      cmd="pigz"
    else
      cmd="gzip"
    fi
  fi

  echo "Compressing .tar using \`${cmd}\`…"
  "${cmd}" -v "${tmpFile}" || return 1
  [ -f "${tmpFile}" ] && rm "${tmpFile}"
  echo "${tmpFile}.gz created successfully."
}


## __NAVIGATION__ ##

# Go back N-dots-directories
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'


# Quick navigation between folders
# Usage:
#             $ mark any_name           # marks the current directory and adds a reference to it called any_name
#             $ jump any_name           # jumps to the marked directory named any_name
#             $ unmark any_name       # removes the reference
#             $ marks                           # lists all curent marks
# Source:
#         http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
jump() {
  cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
mark() {
  mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
unmark() {
  rm -i "$MARKPATH/$1"
}
marks() {
  ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}
alias j="jump"


# Highlights and prints the lines numbers of all non US ASCII characters
# Usage:
#       $ print_non_usascii path/to/file
print_non_usascii() {
  if [ "$(uname)" == "Darwin" ]; then
    pcregrep --color='auto' -n "[\x80-\xFF]"
  else
    echo "Only checked on OSX"
    echo "Can be installed with 'sudo apt-get install pcregrep'"
  fi
}


## __TERMINAL__ ##

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

## __PROGRAMMING__ ##

lein() {
  if [[ ! -f /bin/lein ]]; then
    echo "Lein clojure not installed"
    echo "Installing..."
    __dot-bash-install-lein-clojure
  fi
  /bin/lein "$@"
}

## __NETWORKING__ ##

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "$method"="lwp-request -m '$method'"
done

# Create a data URL from a file
dataurl() {
  if [[ -z "$1" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t dataurl <path_to_file>"
    echo "creates a data URL from specified file."
  else
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
      mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
  fi
}

# URL-encode strings
urlencode() {
  if [[ -z "$1" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t urlencode <any_string>"
    echo "URL-encodes specified string"
  else
    python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"
  fi
}

# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# Makes localhost accessible through a tunnel
ngrok() {
  if [ ! -f ~/.buren/bin/ngrok ];then
    echo "Ngrok not found in ~/.buren/bin/ngrok."
    __dot-bash-install-ngrok
    echo "Installation finished."
  fi

  if [[ -z "$1" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t ngrok <port>"
    echo "or if ~/.ngrok config is set up"
    echo -e "\t ngrok start <service>"
    echo "serve localhost on port"
    echo "alias: servelocalhost"
  else
    echo "Starting ngrok"
    ~/.buren/bin/ngrok "$@" # $1 port
  fi
}
alias servelocalhost='ngrok'

# Simple HTTPS server, serving current directory
servethis() {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t servethis <optional_directory>"
    echo "serve the current/specified directory"
  else
    if [ ! -z "$1" ]; then
      cd $1
    fi
    ret=`python -c 'import sys; print("%i" % (sys.hexversion<0x03000000))'`
    if [ $ret -eq 0 ]; then    # Python version is >= 3
      python -c 'python -m http.server 8765'
    else                       # Python version is < 3
      python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'
    fi
  fi
}

servethis-node() {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t servethis-node <optional_directory>"
    echo "serve the current/specified directory"
  else
    if [[ ! -d ~/.buren/bin/simple-file-server ]]; then
      echo "Simple file server not found, downloading..."
      __dot-bash-install-node-file-server
    fi
    node ~/.buren/bin/simple-file-server/server.js --port 8000 --folder $1
  fi
}

cast-local() {
  if [[ ! -d ~/.buren/bin/cast-localvideo ]]; then
    __dot-bash-install-cast-localvideo
  fi
  if [[ $1 == "-h" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "usage:"
    echo -e "\t cast-local"
    echo "Cast (almost) any local video format."
    echo "Will start a web server at localhost:8000"
  fi
  cd ~/.buren/bin/cast-localvideo/ && node app.js
}
alias cast-local-video='cast-local'

speedtest() {
  wget http://cachefly.cachefly.net/100mb.test
  rm 100mb.test
}

# Simple chat server
chat_client() {
  if [[ -z "$1" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t chat_server <optional_port>"
    echo "connects to chat server on <ip> <optional_port>"
    echo "Default port: 55555"
  else
    echo "Initalizing chat client"
    echo "Listening on $1 port ${2-55555}"
    nc $1 ${2-55555}
  fi
}

chat_server() {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t chat_server <optional_port>"
    echo "starts chat server on port <optional_port>"
    echo "Default port: 55555"
  else
    echo "Initalizing chat server"
    echo "On the other computer type:"
    echo nc $(localip) ${1-55555}
    nc -l ${1-55555}
  fi
}

trace() {
  if [ "$(uname)" == "Darwin" ]; then
    if [[ ! -d '/usr/local/Cellar/mtr' ]]; then
      echo "mtr not found installing"
      __install-osx-mtr
    fi
  fi
  mtr $@
}
alias mtr='trace'


# Show active network listeners
alias netlisteners='netstat -untap'
alias checkconnection="ping www.google.com"

# Get external IP
alias myip='curl ip.appspot.com'
alias externalip='myip'


scan_network() {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t scan_network <optional_scan_range>"
    echo "scans network for online hosts"
    echo "Default range: $B_NETWORK_RANGE"
  else
    if [[ -z "$1" ]]; then
      sudo nmap -sV -vv -PN $B_NETWORK_RANGE
    else
      sudo nmap -sV -vv -PN $1
    fi
  fi
}

scan_secret() {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t scan_secret <optional_scan_range>"
    echo "scans network for online hosts and open ports. (verbose)"
    echo "Default range: $B_NETWORK_RANGE"
  else
    if [[ -z "$1" ]]; then
      sudo nmap -sn -PE $B_NETWORK_RANGE
    else
      sudo nmap -sn -PE $1
    fi
  fi
}

alias scan_network_deep='sudo nmap -sC --script=smb-check-vulns --script-args=safe=1 --script-args=unsafe=1 -p445  -d -PN -n -T4  --min-hostgroup 256 --min-parallelism 64  -oA conficker_scan -O --osscan-guess $B_NETWORK_RANGE'

alias scan_ssh='nmap -p 22 --open -sV $B_NETWORK_RANGE'

scan_firewall() {
  ## TCP Null Scan to fool a firewall to generate a response ##
  ## Does not set any bits (TCP flag header is 0) ##
  sudo nmap -sN $1;
  ## TCP Fin scan to check firewall ##
  ## Sets just the TCP FIN bit ##
  sudo nmap -sF $1;
  ## TCP Xmas scan to check firewall ##
  ## Sets the FIN, PSH, and URG flags, lighting the packet up like a Christmas tree ##
  sudo nmap -sX $1;
}
# Scans what ports are open on given ip-address
scan_openports() {
  sudo nmap -sS $1
}
# Checks the operating system and other data for give ip-address
scan_os() {
  sudo nmap -O --osscan-guess $1
}
# Logs all GET and POST requests on port 80
alias sniff="sudo ngrep -d 'wlan0' -t '^(GET|POST) ' 'tcp and port 80'"

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


## __RAILS__ ##

# Rails aliases
alias rs='bundle exec rails server'
alias rc='bundle exec rails console'
alias rmigrate='bundle exec rake db:migrate'
alias rroutes='bundle exec rake routes'

alias ruby2='rvm use 2.0.0'
alias ruby19='rvm use 1.9.3'

## __GIT__ ##
git config --global help.autocorrect 20 # Auto correct misspellings
git config --global color.ui auto       # Use colors by default
git config --global merge.stat true     # Always show merge stats

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


# add a github remote by github username
function gra() {
  if (( "${#@}" != 1 )); then
    echo "Usage: gra githubuser"
    return 1;
  fi
  local repo=$(gr show -n origin | perl -ne '/Fetch URL: .*github\.com[:\/].*\/(.*)/ && print $1')
  gr add "$1" "git://github.com/$1/$repo"
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


## __HEROKU__ ##

alias hdeploy='git push heroku master'
alias hconsole='heroku run console'
alias hmigrate='heroku run rake db:migrate && heroku restart'
alias hdeploymigrate='hdeploy && hmigrate'


## __UTILITY SCRIPTS__ ##

download() {
  if [[ -z "$1" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t download --url=<url> --types=<first> <second> --selector=<html_selector>"
    echo "Required options: --url"
    echo "Optional options: --types=<first> <second> --selector=<html_selector>"
    echo "Example:"
    echo -e "\t download --url=example.com --types=pdf zip java --selector=.html-class"
  elif [ -d ~/.buren/util_scripts/ ]; then
    rvm use 2.0.0 && ~/.buren/util_scripts/downloader.thor fetch "$@"
  else
    echo "Cannot find ~/.buren/util_scripts/downloader.thor"
    __dot-bash-util-scripts-install
  fi
}



## __MISC__ ##

alias starwars='traceroute 216.81.59.173'
alias print_ascii='man ascii'

alias resize_to_width='convert -resize' # Resize args to width, keep aspect ratio

cleanup_whiteboard() {
  if [[ $1 == "--help" ]] || [[ $1 == "-help" ]] || [[ $1 == "-h" ]]; then
    echo "Clean up whiteboard picture"
    echo "Usage: cleanup_whiteboard <input-image> <output-image>"
    return
  fi
  convert $1 -morphology Convolve DoG:15,100,0 -negate -normalize -blur 0x1 -channel RBG -level 60%,91%,0.1 $2
}


2048-game() {
  if [[ ! -d ~/.buren/bin/sed2048 ]]; then
    echo -e "Could't not find 2048-sed.. Installing..."
    __install-2048-sed
  fi
  bash ~/.buren/bin/sed2048/src/2048.sh
}

# Shorten given URL
shortenurl() {
  curl -s http://is.gd/api.php?longurl=`perl -MURI::Escape -e "print uri_escape('$1');"`
  echo
}

# Display URL true destination
expandurl() {
  curl -sIL $1 | grep ^Location
}

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}
alias settitle='titlebar'

function phpserver() {
  local port="${1:-4000}"
  # local ip=$(ipconfig getifaddr en1)
  local ip='192.168.0.103'
  sleep 1 && open "http://${ip}:${port}/" &
  php -S "${ip}:${port}"
}

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
