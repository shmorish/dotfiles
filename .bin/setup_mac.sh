#!/bin/bash

set -e

load_functions() {
    export SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
    . "$SCRIPTS_DIR/brew.sh"
}

main() {
    load_functions
    install_homebrew
    setup_from_brewfile
    # install node
    # ohmyzsh
}

main