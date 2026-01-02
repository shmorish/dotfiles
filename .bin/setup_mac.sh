#!/bin/bash

load_functions() {
    export SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
    . "$SCRIPTS_DIR/brew.sh"
    . "$SCRIPTS_DIR/oh-my-zsh.sh"
}

main() {
    load_functions
    install_homebrew
    install_ohmyzsh
}

main