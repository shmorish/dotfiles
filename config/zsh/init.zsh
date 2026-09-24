#!/bin/zsh

CONFIG_DIR="$HOME/.config/zsh/config"

# ------------ My Configs ------------ #
[ -d "$CONFIG_DIR" ] && for config in "$CONFIG_DIR"/*.zsh; do
  source "$config"
done
