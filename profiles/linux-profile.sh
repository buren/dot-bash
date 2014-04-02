#!/bin/bash

# __LINUX__ ##

# Add the below lines to sudoers file (at the bottom):
#       $ sudo visudo           # only way to edit sudoers file
#      <username> ALL=(ALL) ALL
#      <username> ALL = NOPASSWD: /usr/sbin/pm-suspend
# Suspend computer after N-min (Linux specific)
sleepin() {
  if [[ -z "$1" ]]; then
    pmset sleepnow
  else
    echo "Sleeping in $(bc <<< $1*60) minutes"
    sleep $(bc <<< $1*60) && sudo pm-suspend
  fi
}

alias install='sudo apt-get install'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias remove="sudo apt-get remove"
alias search="apt-cache search"

# Mac OSX like 'open' command
# Opens the given input with the default program associated for that type
open() {
  xdg-open $1
}

# Quick look online hosts
alias whoisup='fping -c1 -gds 192.168.1.0/24 2>&1| egrep -v "ICMP|xmt"'

google_say() { local IFS=+;/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?tl=en&q=$*"; }

alias ls='ls --color=auto'
alias la='ls -a --color=auto'
alias ll="ls -l --color=auto"
alias grep='grep --color=auto'

# Get local IP
alias localip="hostname -I"

## __UBUNTU__ ##

alias battery_status='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
# Set battery to use time policy
alias battery_set_time_policy='gsettings set org.gnome.settings-daemon.plugins.power use-time-for-policy true'
# Set battery to use percentage policy.
alias battery_set_percent_policy='gsettings set org.gnome.settings-daemon.plugins.power use-time-for-policy false'
# Set battery percentage required to give you a warning. Ubuntu default is 10%.
# Needs numeric argument for new percentage (Current value: 30)
alias battery_set_warning_percentage='gsettings set org.gnome.settings-daemon.plugins.power percentage-low'
# Set battery considered critical level. Ubuntu default is 3%.
# Needs numeric argument for new percentage (Current value: 25)
alias battery_set_critical_percentage='gsettings set org.gnome.settings-daemon.plugins.power percentage-critical'
# Set battery percentage required to take the critical action. Ubuntu default is 2%.
# Needs numeric argument for new percentage (Current value: 20)
alias battery_set_critical_action_percentage='gsettings set org.gnome.settings-daemon.plugins.power percentage-action'

# Launch shortcut creator [Ubuntu specific]
alias shortcut_creator='sudo gnome-desktop-item-edit /usr/share/applications/ --create-new'

say() {
  local IFS=+
  /usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?tl=en&q=$*"
}
