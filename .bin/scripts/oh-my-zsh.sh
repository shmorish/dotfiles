#!/bin/zsh

install_ohmyzsh() {
  if [ -d "$HOME/dotfiles/oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed."
    return
  fi
  ZSH="$HOME/dotfiles/oh-my-zsh" REPO="shmorish/ohmyzsh" \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/shmorish/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/dotfiles/oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

uninstall_ohmyzsh() {
  ZSH="$HOME/dotfiles/oh-my-zsh" REPO="shmorish/ohmyzsh" \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/shmorish/ohmyzsh/master/tools/uninstall.sh)"
}
