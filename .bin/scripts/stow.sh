#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

stow_dirs=(
    "zsh"
    "git"
    "vim"
    "karabiner"
    "wezterm"
)

_remove_symlinks() {
    local files=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.vimrc"
    )
    local dirs=(
        "$HOME/.config/karabiner"
        "$HOME/.config/wezterm"
        "$HOME/.config/git"
        "$HOME/.config/zsh"
    )
    for file in "${files[@]}"; do
        if [ -L "$file" ]; then
            rm "$file"
            echo -e "${GREEN}Removed symlink: $file${NC}"
        fi
    done
    for dir in "${dirs[@]}"; do
        if [ -L "$dir" ]; then
            rm -rf "$dir"
            echo -e "${GREEN}Removed symlink: $dir${NC}"
        fi
    done
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
    _remove_symlinks
    for dir in "${stow_dirs[@]}"; do
        _set_symlinks "$dir"
    done
}

unset_symlinks_with_stow() {
    for dir in "${stow_dirs[@]}"; do
        stow --dir="$HOME/dotfiles" --target="$HOME" --delete "$dir"
    done
}