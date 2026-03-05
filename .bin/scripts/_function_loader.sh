#!/bin/zsh

load_functions() {
    __DOTFILE_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
    . "$__DOTFILE_SCRIPTS_DIR/brew.sh"
    . "$__DOTFILE_SCRIPTS_DIR/stow.sh"
    . "$__DOTFILE_SCRIPTS_DIR/node.sh"
}
