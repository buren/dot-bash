## __OS X__ ##

alias ls='ls -G'
alias la='ls -a'

# Adds color to osx terminal
export CLICOLOR=1

# Alias for opening Sublime text 2
alias slime='open -a "Sublime Text 2"'
alias subl='slime'

alias localip='ipconfig getifaddr en0'

# Overide 'marks' function in .unix-profile (to work consistently across osx/linux)
function marks {
    \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}


## __HOMEBREW__ ##

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
