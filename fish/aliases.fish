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


# Recursively delete `.DS_Store` files
alias cleanup_dsstore="find . -name '*.DS_Store' -type f -ls -delete"



# Update installed Ruby gems, Homebrew, npm, and their installed packages
alias brew_update="brew -v update; brew upgrade --force-bottle --cleanup; brew cleanup; brew cask cleanup; brew prune; brew doctor; npm-check -g -u"
alias update_brew_npm_gem='brew_update; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update --no-document'


# File size
alias fs="stat -f \"%z bytes\""


# Snaptravel st command
alias st="python3 /Users/nehiljain/snaptravel/devops/st.py"