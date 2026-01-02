#!/bin/bash

uninstall_homebrew () {
    command -v brew >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
    else
        echo "Homebrew is not installed."
    fi
}

main () {
    uninstall_homebrew
}

main