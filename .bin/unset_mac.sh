#!/bin/bash

set -e

load_functions() {
    export SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
    . "$SCRIPTS_DIR/brew.sh"
}


main () {
    load_functions
    uninstall_homebrew
}

main