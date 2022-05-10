#!/bin/bash

# Copy dotfiles
# ./copy.sh

# Update Ubuntu and get standard repository programs
sudo apt update && sudo apt full-upgrade -y

install () {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    sudo apt install -y $1
  else
    echo "Already installed: ${1}"
  fi
}

# Basics
install build-essential
install neovim
install python3-pip
install python3-dev
install autoconf
install	automake
install bzip2
install dpkg-dev
install file
install g++
install gcc
install	libbz2-dev
install	libc6-dev
install	libcurl4-openssl-dev
install	libdb-dev
install	libevent-dev
install	libffi-dev
install	libgdbm-dev
install	libglib2.0-dev
install	libreadline-dev
install	libssl-dev
install	libyaml-dev
install	make
install	patch
install	unzip
install	xz-utils
install	zlib1g-dev
install awscli
install chrome-gnome-shell
install curl
install exfat-utils
install file
install git
install htop
install jq
install yq
install nmap
install openvpn
install tree
install vim
install wget

# Image processing
install gimp
install jpegoptim
install optipng

# Run all scripts in programs/
for f in programs/*.sh; do bash "$f" -H; done

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y
