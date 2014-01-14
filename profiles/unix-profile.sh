#!/bin/bash

set completion-ignore-case On # Ignore case on tab auto complete

## __DOT_BASH__ ##
source ~/.buren/dot-bash/setup/profile-install/unix-profile-install.sh # Install functions

## __UNIX__ ##

alias resource="source ~/.bash_profile"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

alias rsync='rsync --progress'

# Counts the number of files in folder
count_files() {
  ls $1 | wc -l
}

alias lc='count_files' # short hand for the above function

alias hs='history | grep --color=auto'
alias o='open'
alias c='clear'
alias mv='mv -i' # prompt if duplicate filename
# Colored and paginated directory tree
alias tree='tree -C $* | less -R'
# Search running processes
alias tm='ps -ef | grep --color=auto'

# Do sudo to a command, or do sudo to the last typed command if no argument given
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
  pcregrep --color='auto' -n "[\x80-\xFF]"
}


## __TERMINAL__ ##

terminal-dark()  {
  if [[ ! -d ~/.buren/terminal-themes/gnome-terminal-colors-solarized ]]; then
    echo "Terminal themes not installed"
    __dot-bash-install-solarized-terminal-colors
  fi
  sh ~/.buren/terminal-themes/gnome-terminal-colors-solarized/set_dark.sh
}
terminal-light()  {
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
servelocalhost() {
  if [ ! -f ~/.buren/bin/ngrok ];then
    echo "Ngrok not found in ~/.buren/bin/ngrok."
    __dot-bash-install-ngrok
    echo "Installation finished."
  fi

  if [[ -z "$1" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t servelocalhost <port>"
    echo "serve localhost on port"
  else
    echo "Starting ngrok"
    ~/.buren/bin/ngrok $1 # $1 port
  fi
}

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
    python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'
  fi
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


## __RAILS__ ##

# Rails aliases
alias rs='bundle exec rails server'
alias rc='bundle exec rails console'
alias rmigrate='bundle exec rake db:migrate'
alias rroutes='bundle exec rake routes'

## __GIT__ ##

alias gdiff='git diff --color'
alias gshow='git show  --color'
alias glog='git log --graph --full-history --all --color'
alias gadd='git add .'
alias gcheck='git checkout'
alias gbranch='git branch'

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


## __HEROKU__ ##

alias hdeploy='git push heroku master'
alias hconsole='heroku run console'
alias hmigrate='heroku run rake db:migrate && heroku restart'



## __UTILITY SCRIPTS__ ##

download() {
  if [[ -z "$1" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t download --url=<url> --types=<first> <second> --selector=<html_selector>"
    echo "Required options: --url"
    echo "Optional options: --types=<first> <second> --selector=<html_selector>"
    echo "Example:"
    echo -e "\t download --url=example.com --types=pdf zip java --selector=.html-class"
  elif [ ! -d ~/.buren/util_scripts/ ]; then
    rvm use 2.0.0 && ~/.buren/util_scripts/downloader.thor fetch "$@"
  else
    echo "Cannot find ~/.buren/util_scripts/downloader.thor"
    __dot-bash-util-scripts-install
  fi
}



## __MISC__ ##

alias starwars='traceroute 216.81.59.173'
alias print_ascii='man ascii'
