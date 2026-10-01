#!/bin/zsh

_SCRIPTS_DIR="$HOME/dotfiles/.bin/scripts"
. "$_SCRIPTS_DIR/nix.sh"
. "$_SCRIPTS_DIR/macos.sh"

# Home Manager が張った symlink とプロファイル、macOS の個人設定を元に戻す。
# Nix 本体の削除は `make nix-uninstall` に分離している (誤爆防止)。
main () {
    home_manager_uninstall
    enable_rcd
}

main
