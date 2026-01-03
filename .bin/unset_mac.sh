#!/bin/zsh

__DOTFILE_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
. "$__DOTFILE_SCRIPTS_DIR/_function_loader.sh"

main () {
    load_functions
    unset_symlinks_with_stow
    uninstall_ohmyzsh
    uninstall_homebrew
}

main