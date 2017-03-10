#!/bin/bash

if [[ $SHELL != "/bin/zsh" ]]; then
  # SSH auto-completion based on entries in known_hosts.
  if [[ -e ~/.ssh/known_hosts ]]; then
    complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
  fi
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
