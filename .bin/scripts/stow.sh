#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

_remove_files() {
    rm -f "$HOME/.zshrc"
}

_set_symlinks() {
    stow --dir="$HOME/dotfiles" --target="$HOME" $1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Symlinks for $1 set successfully.${NC}"
    else
        echo -e "${RED}Failed to set symlinks for $1.${NC}"
    fi
}

set_symlinks_with_stow() {
    _remove_files
    _set_symlinks zsh
    _set_symlinks git
    _set_symlinks nvm
    _set_symlinks vim
}

unset_symlinks_with_stow() {
    stow --dir="$HOME/dotfiles" --target="$HOME" --delete zsh
    stow --dir="$HOME/dotfiles" --target="$HOME" --delete git
    stow --dir="$HOME/dotfiles" --target="$HOME" --delete nvm
    stow --dir="$HOME/dotfiles" --target="$HOME" --delete vim
}