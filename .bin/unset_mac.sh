#!/bin/zsh

_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
. "$_SCRIPTS_DIR/nix.sh"

# Home Manager が張った symlink とプロファイルだけを外す。
# Nix 本体の削除は `make nix-uninstall` に分離している (誤爆防止)。
main () {
    home_manager_uninstall
}

main
