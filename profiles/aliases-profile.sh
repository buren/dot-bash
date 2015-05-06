#!/bin/bash

## __HEROKU__ ##

alias hdeploy='git push heroku master'
alias hconsole='heroku run console'
alias hmigrate='heroku run rake db:migrate && heroku restart'
alias hdeploymigrate='hdeploy && hmigrate'

## __Ruby / RAILS__ ##

# Rails aliases
rails_run() {
  local cmd="$@"
  local run_cmd=''
  if [[ -f bin/spring ]];then
    local run_cmd='bin/spring'
  else
    local run_cmd='bundle exec'
  fi
  local full_cmd="$run_cmd $cmd"
  $full_cmd
}

alias be='bundle exec'
alias sp='bin/spring'
alias sup='sp rails g'
alias sdown='sp stop'

alias rs='rails_run rails server'
alias rsb='rails_run rails server --binding=127.0.0.1'
alias rso='rails_run rails server --binding=0.0.0.0'
alias rsopen='rso'
alias rc='rails_run rails console'
alias rmigrate='rails_run rake db:migrate'
alias rspec='rails_run rspec'
alias rroutes='rails_run rake routes'

alias ruby2='rvm use 2.0.0'
alias ruby19='rvm use 1.9.3-p392'
