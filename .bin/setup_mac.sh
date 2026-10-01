#!/bin/zsh

_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
. "$_SCRIPTS_DIR/nix.sh"
. "$_SCRIPTS_DIR/macos.sh"

main () {
    install_nix
    home_manager_switch
    disable_rcd
}

main
