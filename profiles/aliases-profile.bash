#!/bin/bash

## __HEROKU__ ##

alias hdeploy='git push heroku master'
alias hconsole='heroku run console'
alias hmigrate='heroku run rake db:migrate && heroku restart'
alias hdeploymigrate='hdeploy && hmigrate'

## __Ruby / RAILS__ ##

# Rails aliases
alias be='bundle exec'
alias sdown='spring stop'

alias rs='test -f bin/rails && bin/rails server || \rails'
alias rsb='test -f bin/rails && bin/rails server --binding=127.0.0.1 || \rails server --binding=127.0.0.1'
alias rso='test -f bin/rails && bin/rails server --binding=0.0.0.0 || \rails server --binding=0.0.0.0'
alias rsopen='rso'
alias rc='test -f bin/rails && bin/rails console || \rails console'
alias rmigrate='test -f bin/rake && bin/rails db:migrate || \rails db:migrate'
alias rroutes='test -f bin/rake && bin/rake routes "$@" || \rake "$@"'

function rails() {
  test -f bin/rails && bin/rails "$@" || \rails "$@"
}

function rspec() {
  test -f bin/rspec && bin/rspec "$@" || \rspec "$@"
}

function rake() {
  test -f bin/rake && bin/rake "$@" || \rake "$@"
}
