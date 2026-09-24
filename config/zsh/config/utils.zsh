#!/bin/zsh

# Home Manager: 再適用して補完キャッシュを作り直す
hms() {
  home-manager switch --flake "$HOME/dotfiles" "$@" || return $?
  echo "Refreshing completions..."
  rm -f ${HOME}/.zcompdump*
  compinit
}

# zsh utilities
alias zshrc='nvim ~/.zshrc && source ~/.zshrc'

# Weather information using wttr.in
weather () {
  if [ -z "$1" ]; then
    curl "wttr.in"
  else
    curl "wttr.in/$1"
  fi
}

# Get public IP address
public_ip () {
  echo "IPv4 -> $(curl -s https://ipv4.icanhazip.com/)"
  echo "IPv6 -> $(curl -s https://ipv6.icanhazip.com/)"
}
