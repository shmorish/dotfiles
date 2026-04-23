#!/bin/zsh

_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
. "$_SCRIPTS_DIR/brew.sh"
. "$_SCRIPTS_DIR/stow.sh"

main () {
    install_homebrew
    set_symlinks_with_stow
    mise install
}

main