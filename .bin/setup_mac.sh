#!/bin/zsh

_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
. "$_SCRIPTS_DIR/brew.sh"
. "$_SCRIPTS_DIR/stow.sh"
. "$_SCRIPTS_DIR/node.sh"

main () {
    install_homebrew
    set_symlinks_with_stow
    install_node
}

main