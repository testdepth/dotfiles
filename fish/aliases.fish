# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end


# Utilities
function g        ; git $argv ; end
function grep     ; command grep --color=auto $argv ; end


alias cask='brew cask' # i <3 u cask
alias where=which # sometimes i forget



alias diskspace_report="df -P -kHl"
alias free_diskspace_report="diskspace_report"

alias master="git checkout master"


# Git Aliases
alias gst='git status'
#compdef _git gst=git-status
alias gl='git pull'
#compdef _git gl=git-pull
alias gup='git pull --rebase'
#compdef _git gup=git-fetch
alias gpu='git push -u origin (git_current_branch)'
#compdef _git gpu=git-push
alias gcb='git checkout -b'

alias gcom='git checkout master'

alias ga='git add'

alias gaa='git add --all'

alias grm='git rm'

alias grmc='git rm --cached'
alias gcm='git commit -m'
alias gcam='git commit -a -m'



# Recursively delete `.DS_Store` files
alias cleanup_dsstore="find . -name '*.DS_Store' -type f -ls -delete"



# Update installed Ruby gems, Homebrew, npm, and their installed packages
alias brew_update="brew -v update; brew upgrade --force-bottle --cleanup; brew cleanup; brew cask cleanup; brew prune; brew doctor; npm-check -g -u"
alias update_brew_npm_gem='brew_update; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update --no-document'


# File size
alias fs="stat -f \"%z bytes\""


# Snaptravel st command
alias st="python3 /Users/nehiljain/snaptravel/devops/st.py"
