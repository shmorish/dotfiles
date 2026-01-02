#!/bin/bash

_setup_from_brewfile() {
    config_file="$HOME/dotfiles/.config/Brewfile"
    command -v brew >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Homebrew is not installed. Cannot setup from Brewfile."
        return 1
    fi
    if [ -f "$config_file" ]; then
        brew bundle --file="$config_file"
    else
        echo "Brewfile not found."
    fi
}

install_homebrew() {
    command -v brew >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
    fi
    brew update
    _setup_from_brewfile
}

uninstall_homebrew () {
    command -v brew >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
    else
        echo "Homebrew is not installed."
    fi
}
