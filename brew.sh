#!/usr/bin/env bash


# Install Brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install homebrew cask 
brew install caskroom/cask/brew-cask 

# Install Iterm
brew cask install iterm2


# Google Chrome
brew cask install google-chrome

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install a modern version of Bash.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;


# Install GnuPG to enable PGP-signing commits.
brew install gpg

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh
brew install screen
brew install gmp
brew install fish

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install bfg
brew install tree
brew install nmap
brew install xz

# Install other useful binaries.
brew install ack
brew install git
brew install git-lfs
brew install imagemagick --with-webp
brew install pigz
brew install pv
brew install rename
brew install ssh-copy-id
brew cask install ngrok

# Install useful Frontend tools
brew install node
brew install hugo
# Install useful languages
brew install go
brew cask install java 
brew install pyenv
brew install pyenv-virtualenv

# Install R and RStudio
brew install R
brew install Caskroom/cask/rstudio

brew install wget


brew cask install postman
brew install terraform
brew install awscli
brew cask install anaconda
brew cask install keepingyouawake
brew cask install flux
brew cask install slack
brew cask install pritunl
brew cask install visual-studio-code 
brew cask install cyberduck
brew install lastpass-cli
brew cask install cheatsheet
brew install mas
brew cask install spotify
brew install cask 'google-drive'
# Install Databases
brew install postgresql


# Docker
brew cask install docker

# Remove outdated versions from the cellar.
brew cleanup


cd /Applications && curl http://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz | tar -xz

curl https://raw.githubusercontent.com/GitAlias/gitalias/master/gitalias.txt -o ~/.git
