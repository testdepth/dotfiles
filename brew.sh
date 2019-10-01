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
brew install vim --with-override-system-vi
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
brew install aircrack-ng
brew install bfg
brew install tree
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
brew install xpdf
brew install xz

# Install other useful binaries.
brew install ack
#brew install exiv2
brew install git
brew install git-lfs
brew install gs
brew install imagemagick --with-webp
brew install lynx
brew install pigz
brew install pv
brew install rename
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli
brew install ngrok

# Install useful Frontend tools
brew install node

# Install useful languages
brew install go
brew cask install java 
brew install pyenv
brew install pyenv-virtualenv

# Install R and RStudio
brew tap homebrew/science
brew install R
brew install Caskroom/cask/rstudio

brew install dbt
brew install wget


brew cask install postman
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

# Install Databases
brew install postgresql


# Docker
brew cask install docker

# Remove outdated versions from the cellar.
brew cleanup


cd /Applications && curl http://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz | tar -xz

curl https://raw.githubusercontent.com/GitAlias/gitalias/master/gitalias.txt -o ~/.git
