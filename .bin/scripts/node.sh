#!/bin/zsh

__install_node_version() {
    local version=$1
    nvm install "$version"
}

install_node () {
    source "$HOME/.zshrc"
    command -v nvm >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "nvm is not installed. Please install nvm first."
        return 1
    fi
    LTS_NODE_VERSION=$(nvm ls-remote | grep 'Latest LTS' | tail -n 1 | sed -nE 's/.*(v[0-9]+\.[0-9]+\.[0-9]+).*/\1/p')
    INSTALL_VERSION=(v12.16.1 v22.17.1 ${LTS_NODE_VERSION})
    for version in $INSTALL_VERSION; do
        __install_node_version "$version"
    done
    nvm alias default "$LTS_NODE_VERSION"
    nvm use default
}

uninstall_node () {
    NVM_DIR="$HOME/.nvm"
    rm -rf "$NVM_DIR/versions/node"
    rm -rf "$NVM_DIR/alias"
    rm -rf "$NVM_DIR/.cache"
}
