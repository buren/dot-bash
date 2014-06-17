#!/bin/bash

## __HEROKU__ ##

alias hdeploy='git push heroku master'
alias hconsole='heroku run console'
alias hmigrate='heroku run rake db:migrate && heroku restart'
alias hdeploymigrate='hdeploy && hmigrate'

## __Ruby / RAILS__ ##

# Rails aliases
alias rs='bundle exec rails server --binding=127.0.0.1'
alias rc='bundle exec rails console'
alias rmigrate='bundle exec rake db:migrate && bundle exec rake db:test:prepare'
alias rroutes='bundle exec rake routes'

alias ruby2='rvm use 2.0.0'
alias ruby19='rvm use 1.9.3-p392'
