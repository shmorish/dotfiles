#!/bin/zsh

install_herdr() {
    command -v herdr >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "herdr is already installed: $(herdr --version)"
        return 0
    fi
    curl -fsSL https://herdr.dev/install.sh | sh
}
