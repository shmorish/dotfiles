#!/bin/zsh

_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
. "$_SCRIPTS_DIR/nix.sh"

main () {
    install_nix
    home_manager_switch
}

main
