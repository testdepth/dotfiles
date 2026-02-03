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
brew install homebrew/cask

# Install Iterm
brew install --cask iterm2

# Google Chrome
brew install --cask google-chrome

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
brew install neovim
brew install tmux
brew install reattach-to-user-namespace
brew install grep
brew install ripgrep
brew install fzf
brew install bat
brew install fd
brew install openssh
brew install screen
brew install gmp
brew install fish

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

brew install bfg


# Install other useful binaries.
brew install ack
brew install git
brew install git-lfs
brew install imagemagick --with-webp
brew install pigz
brew install pv
brew install rename
brew install ssh-copy-id
brew install --cask ngrok

# Install useful Frontend tools
brew install node
brew install hugo
# Install useful languages
brew install python
brew install python3
brew install --cask java
brew install pyenv
brew install pyenv-virtualenv

brew install wget


brew install --cask postman
brew install terraform
# Removed: brew install --cask anaconda (use pyenv + uv instead)
brew install --cask keepingyouawake
brew install --cask flux
brew install --cask slack
brew install --cask visual-studio-code
brew install --cask cyberduck
brew install --cask cheatsheet
brew install mas
brew install --cask spotify
brew install --cask rectangle
brew install pandoc
# Install Databases
brew install postgresql


# Docker
brew install --cask docker

# Remove outdated versions from the cellar.
brew cleanup



curl https://raw.githubusercontent.com/GitAlias/gitalias/master/gitalias.txt -o ~/.git
