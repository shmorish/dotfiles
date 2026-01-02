#!/bin/bash

load_functions() {
    __DOTFILE_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
    . "$__DOTFILE_SCRIPTS_DIR/brew.sh"
    . "$__DOTFILE_SCRIPTS_DIR/oh-my-zsh.sh"
    . "$__DOTFILE_SCRIPTS_DIR/stow.sh"
}
