#!/bin/zsh

__DOTFILE_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
. "$__DOTFILE_SCRIPTS_DIR/_function_loader.sh"

main () {
    load_functions
    install_homebrew
    install_ohmyzsh
    set_symlinks_with_stow
    install_node
}

main