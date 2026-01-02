#!/bin/sh

install_ohmyzsh() {
  ZSH="$HOME/dotfiles/oh-my-zsh" REPO="shmorish/ohmyzsh" \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/shmorish/ohmyzsh/master/tools/install.sh)" "" --unattended
}

uninstall_ohmyzsh() {
  ZSH="$HOME/dotfiles/oh-my-zsh" REPO="shmorish/ohmyzsh" \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/shmorish/ohmyzsh/master/tools/uninstall.sh)"
}
