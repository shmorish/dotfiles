#!/bin/bash

# check if zsh is installed
if type zsh > /dev/null 2>&1; then
    # chech if oh-my-zsh is installed
    if [ ! -d ~/.oh-my-zsh ]; then
        echo "Install Oh My Zsh"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        # change the theme
        sed -i '' 's/ZSH_THEME="robbyrussell"/ZSH_THEME="shmorish"/' ~/.zshrc
        cp shmorish.zsh-theme ~/.oh-my-zsh/themes/
    else
        echo "Oh My Zsh is already installed"
    fi
    # check if "Doc" alias is not in .zshrc
    if ! grep -q "alias Doc='cd ~/Documents'" ~/.zshrc; then
        echo "Add original aliases to .zshrc"
        cat ~/.zshrc > .zshrc.bak
        cat .zshrc.template > ~/.zshrc
        cat .zshrc.bak >> ~/.zshrc
        rm .zshrc.bak
    else
        echo "Original aliases are already installed"
    fi
else
    echo "zsh is not installed"
fi