## __DOT_BASH__ ##

alias resource="source ~/.bash_profile"

# dot-bash import
function update_dot_bash {
  cd ~/.buren/git-story  && git pull origin master
  cd ~/.buren/dot-bash && git pull origin master
}



## __UNIX__ ##

alias rsync='rsync --progress'

# Counts the number of files in folder
function count_files {
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
please(){
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

# Redo the last command arguments with specified program
# example:
#                 $ ls some_file
#                 $ redo_with cat
function redo_with() {
  $1 $(history -p '!*')
}

function popular_commands {
  cut -f1 -d" " ~/  .bash_history | sort | uniq -c | sort -nr | head -12
}


# Extract a lot of different archieve formats
extract () {
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
        *)     echo "'$1' cannot be extracted via extract()" ;;
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
function jump {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
    rm -i "$MARKPATH/$1"
}
function marks {
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}


# Highlights and prints the lines numbers of all non US ASCII characters
# Usage:
#       $ print_non_usascii path/to/file
function print_non_usascii {
  pcregrep --color='auto' -n "[\x80-\xFF]"
}


## __TERMINAL__ ##

function terminal-dark  {
  if [ ! -d ~/.buren/terminal-themes/gnome-terminal-colors-solarized ]; then
    __install-solarized-terminal-colors
  fi
  sh ~/.buren/terminal-themes/gnome-terminal-colors-solarized/set_dark.sh
}
function terminal-light  {
  if [ ! -d ~/.buren/terminal-themes/gnome-terminal-colors-solarized ]; then
    __install-solarized-terminal-colors
  fi
  sh ~/.buren/terminal-themes/gnome-terminal-colors-solarized/set_light.sh
}



## __NETWORKING__ ##

# Makes localhost accessible through a tunnel
function servelocalhost {
  if [ ! -f ~/.buren/bin/ngrok ];then
    echo "Ngrok not found in ~/.buren/bin/ngrok."
    __dot-bash-install-ngrok
  fi
  ~/.buren/bin/ngrok $1
}

alias chat_server='echo "Starting chat server on" && localip && echo "on port 1567" && echo "Client should run nc "localip"  1567" && nc -l 1567'

# Simple chat server
function simple_chat {
  echo "On the other computer type:"
  echo nc $(hostname -I) 55555
  nc -l 55555
}

# Simple HTTPS server, serving current directory
function servethis {
  if [ ! -z "$1" ]; then
    cd $1
  fi
  python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'
}


# Show active network listeners
alias netlisteners='netstat -untap'
alias checkconnection="ping www.google.com"

# Get external IP
alias myip='curl ip.appspot.com'

# Quick look online hosts
# alias whoisup='fping -c1 -gds 192.168.1.0/24 2>&1| egrep -v "ICMP|xmt"'

# Deep nmap scan for online hosts
alias scan_network='sudo nmap -sn -PE 192.168.0.0/24'

alias scan_secret='sudo nmap -sV -vv -PN 192.168.0.0/24'

alias scan_network_deep='sudo nmap -sC --script=smb-check-vulns --script-args=safe=1 -p445  -d -PN -n -T4  --min-hostgroup 256 --min-parallelism 64  -oA conficker_scan -O --osscan-guess 192.168.0.0/24'

alias scan_ssh='nmap -p 22 --open -sV 192.168.0.0/24'

function scan_firewall {
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
function scan_openports {
  sudo nmap -sS $1
}
# Checks the operating system and other data for give ip-address
function scan_os {
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

function gcommit {
  git add .
  git commit -m "$1"
}

function gpush {
  git add .
  git commit -m "$2"
  git push origin $1
}

function gitfuckit {
  gpush ${1-master} "update"
}


## __HEROKU__ ##

alias hdeploy='git push heroku master'
alias hconsole='heroku run console'
alias hmigrate='heroku run rake db:migrate && heroku restart'



## __UTILITY SCRIPTS__ ##

if [ ! -d ~/.buren/util_scripts/ ]; then
  if [ -f ~/.buren/util_scripts/downloader.thor ]; then
    alias download='rvm use 2.0.0 && ~/.buren/util_scripts/downloader.thor fetch'
  else
    echo "Cannot find ~/.buren/util_scripts/downloader.thor"
  fi
fi


## __MISC__ ##

alias starwars='traceroute 216.81.59.173'
alias print_ascii='man ascii'
