#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath -m .)"
DESTINATION="$(realpath -m ~)"

info "Setting up Vim..."

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
success "Installed Vim Plug"

mkdir -p ~/.config
mkdir -p  ~/.config/nvim

symlink $SOURCE/init.vim $DESTINATION/.config/nvim/init.vim

success "Finished setting up Vim."
