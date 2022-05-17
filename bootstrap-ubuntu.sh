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
sudo apt install build-essential -y
sudo apt install neovim -y
sudo apt install python3-pip -y
sudo apt install python-is-python3 -y
sudo apt install python3-dev -y
sudo apt install autoconf -y
sudo apt install automake -y
sudo apt install bzip2 -y
sudo apt install dpkg-dev -y
sudo apt install file -y
sudo apt install g++ -y
sudo apt install gcc -y
sudo apt install libbz2-dev -y
sudo apt install libc6-dev -y
sudo apt install libcurl4-openssl-dev -y
sudo apt install libdb-dev -y
sudo apt install libevent-dev -y
sudo apt install libffi-dev -y
sudo apt install libgdbm-dev -y
sudo apt install libglib2.0-dev -y
sudo apt install libreadline-dev -y
sudo apt install libssl-dev -y
sudo apt install libyaml-dev -y
sudo apt install zlib1g-dev -y
sudo apt install libbz2-dev -y
sudo apt install libreadline-dev -y
sudo apt install libsqlite3-dev -y
sudo apt install make -y
sudo apt install patch -y
sudo apt install unzip -y
sudo apt install xz-utils -y
sudo apt install zlib1g-dev -y
sudo apt install awscli -y
sudo apt install chrome-gnome-shell -y
sudo apt install curl -y
sudo apt install exfat-utils -y
sudo apt install file -y
sudo apt install git -y
sudo apt install htop -y
sudo apt install jq -y
sudo apt install yq -y
sudo apt install nmap -y
sudo apt install openvpn -y
sudo apt install tree -y
sudo apt install wget -y

# Run all scripts in programs/
# for f in programs/*.sh; do bash "$f" -H; done

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y
