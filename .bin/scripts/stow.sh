#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

stow_dirs=(
    "zsh"
    "git"
    "vim"
    "karabiner"
    "nvim"
    "wezterm"
    "mise"
)

_set_symlinks() {
    stow --dir="$HOME/dotfiles" --target="$HOME" $1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Symlinks for $1 set successfully.${NC}"
    else
        echo -e "${RED}Failed to set symlinks for $1.${NC}"
    fi
}

set_symlinks_with_stow() {
    unset_symlinks_with_stow
    for dir in "${stow_dirs[@]}"; do
        _set_symlinks "$dir"
    done
}

unset_symlinks_with_stow() {
    for dir in "${stow_dirs[@]}"; do
        stow --dir="$HOME/dotfiles" --target="$HOME" --delete "$dir"
    done
}

if [[ "${(%):-%N}" == "$0" ]]; then
    set_symlinks_with_stow
fi