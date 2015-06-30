#!/bin/bash

## __NETWORKING__ ##

headers() {
  curl -sv "$@" 2>&1 >/dev/null |
    grep -v "^\*" |
    grep -v "^}" |
    cut -c3-
}

# One of @janmoesen’s ProTips
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

googlecache() {
  local url=$1
  open "https://webcache.googleusercontent.com/search?q=cache:$url"
}

waybackmachine() {
  local url=$1
  open "https://web.archive.org/web/$url"
}

lan_hosts() {
  echo Scanning..
  local lan_hosts="$(arp -a | grep -v incomplete)"
  echo -e "$lan_hosts"
  echo -e "Found $(echo -e "$lan_hosts" | wc -l) online host(s)"
}

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
    python -c "import sys, urllib as ul; print ul.quote_plus('$1');"
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
    ~/.buren/bin/ngrok "$@"
  fi
}
alias servelocalhost='ngrok'

servethis-ruby() {
  if [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t servethis-node <optional_directory>"
    echo "serve the current/specified directory"
  else
    if [ ! -z "$1" ]; then
      cd $1
    fi
    ruby -run -e httpd . -p 8000
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
    ret=`python -c 'import sys; print("%i" % (sys.hexversion<0x03000000))'`
    if [ $ret -eq 0 ]; then    # Python version is >= 3
      python -c 'python -m http.server 8000'
    else                       # Python version is < 3
      python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'
    fi
  fi
}

servethis-node() {
  mkdir ~/.buren/bin/
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
    echo -e "\t chat_client <ip> <optional_port>"
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
alias chatclient='chat_client'
alias chatserver='chat_server'

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


download() {
  if [[ -z "$1" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]]; then
    echo "Usage:"
    echo -e "\t download --url=<url> --types=<first> <second> --selector=<html_selector>"
    echo "Required options: --url"
    echo "Optional options: --types=<first> <second> --selector=<html_selector>"
    echo "Example:"
    echo -e "\t download --url=example.com --types=pdf zip java --selector=.html-class"
  elif [ -d ~/.buren/util_scripts/ ]; then
    ~/.buren/util_scripts/downloader.thor fetch "$@"
  else
    echo "Cannot find ~/.buren/util_scripts/downloader.thor"
    __dot-bash-util-scripts-install
  fi
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

function phpserver() {
  local port="${1:-4000}"
  # local ip=$(ipconfig getifaddr en1)
  local ip='192.168.0.103'
  sleep 1 && open "http://${ip}:${port}/" &
  php -S "${ip}:${port}"
}


alias save_webpage='wget --page-requisites'

hipchat() {
  local room_id=$DEFAULT_HIPCHAT_ROOM
  local owner_id=$DEAFAULT_OWNER_ID
  local auth_token=$HIPCHAT_AUTH_TOKEN
  local message="$1"
  local color=${2-yellow}
  # Send notification
  curl --header "content-type: application/json" --header "Authorization: Bearer $auth_token" -X POST \
    -d "{\"name\":\"dev\",\"privacy\":\"private\",\"is_archived\":false,\"is_guest_accessible\":false,\"topic\":\"Msg\",\"message\":\"$message\",\"color\":\"$color\",\"owner\":{\"id\":$owner_id}}" https://api.hipchat.com/v2/room/$room_id/notification
}

announce_connection() {
  ((count = 10000))                   # Maximum number to try.
  while [[ $count -ne 0 ]] ; do
    ping -c 1 8.8.8.8                 # Try once.
    rc=$?
    if [[ $rc -eq 0 ]] ; then
        ((count = 1))                 # If okay, flag to exit loop.
    fi
    ((count = count - 1))             # So we don't go forever.
  done

  if [[ $rc -eq 0 ]] ; then           # Make final determination.
    echo $(say The internet is up.)
  else
    echo $(say Timeout.)
  fi
}
