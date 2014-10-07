#!/bin/bash

## __HEROKU__ ##

alias hdeploy='git push heroku master'
alias hconsole='heroku run console'
alias hmigrate='heroku run rake db:migrate && heroku restart'
alias hdeploymigrate='hdeploy && hmigrate'

## __Ruby / RAILS__ ##

# Rails aliases
alias be='bundle exec'
alias rs='be rails server'
alias rc='be rails console'
alias rmigrate='be rake db:migrate && be rake db:test:prepare'
alias rspec='be rspec'
alias rroutes='be rake routes'

alias ruby2='rvm use 2.0.0'
alias ruby19='rvm use 1.9.3-p392'
