#!/usr/bin/env bash

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Shortcuts
alias d="cd ~/Documents/Dropbox"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/projects"
alias g="git"

# git aliases
alias g='git'
alias gp='git pull'
alias gs='git status'
alias gb='git branch'
alias gco='git checkout'
alias gcm='git commit -m'
alias ga='git add'
alias gau='git add -u'
alias pew='git push'
alias pub='git push --set-upstream origin'
#new branch, checkout, publish

alias ghp='GH_HOST=github.com gh'
# goto project

# poetry
alias req='export -f requirements.txt --output requirements.txt --without-hashes'

#vim
alias vi ='nvim'
alias vim='nvim'

#rust torch env
# export LIBTORCH=$(brew --cellar pytorch)/$(brew info --json pytorch | jq -r '.[0].installed[0].version')
# export LD_LIBRARY_PATH=$LIBTORCH/lib:$LD_LIBRARY_PATH