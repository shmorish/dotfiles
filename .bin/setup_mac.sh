#!/bin/zsh

_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
. "$_SCRIPTS_DIR/brew.sh"
. "$_SCRIPTS_DIR/stow.sh"
. "$_SCRIPTS_DIR/claude-code.sh"
. "$_SCRIPTS_DIR/herdr.sh"

main () {
    install_homebrew
    set_symlinks_with_stow
    mise install
    install_claude_code
    install_herdr
}

main