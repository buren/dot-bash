#!/bin/bash

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
