#!/bin/zsh

_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
. "$_SCRIPTS_DIR/brew.sh"
. "$_SCRIPTS_DIR/stow.sh"

main () {
    unset_symlinks_with_stow
    uninstall_homebrew
}

main