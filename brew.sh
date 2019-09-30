#!/usr/bin/env bash


# Install Brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install homebrew cask 
brew install caskroom/cask/brew-cask 

# Install Iterm
brew cask install iterm2


# Google Chrome
# brew cask install google-chrome

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew tap homebrew/versions
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# Install `wget` with IRI support.
brew install wget --with-iri


# Install more recent versions of some macOS tools.
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2


# Install other useful binaries.
brew install ack
brew install fzf
brew install dark-mode
#brew install exiv2
brew install git
brew install git-lfs
brew install ssh-copy-id
brew install testssl
brew install tree
brew install zopfli
brew install ngrok


# Install useful languages
brew cask install java 
brew install pyenv
brew install pyenv-virtualenv

# Install R and RStudio
brew tap homebrew/science
brew install R
brew install Caskroom/cask/rstudio


brew cask install keepingyouawake
brew cask install flux
brew install fish
brew cask install cyberduck
brew install youtube-dl
# Install Databases
brew install postgresql

# Remove outdated versions from the cellar.
brew cleanup
