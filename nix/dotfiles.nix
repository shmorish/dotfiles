{ config, lib, ... }:
let
  # stow の置き換え。store にコピーせずリポジトリ実体へ symlink するので、
  # nvim や karabiner の自己書き込みも動き、編集は即反映 (ファイル追加時だけ `make switch`)。
  link = prefix: names: lib.genAttrs names (n: {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${prefix}/${n}";
  });
in
{
  home.file = link "home" [ ".zshrc" ".vimrc" ];
  xdg.configFile = link "config" [
    # ディレクトリごと
    "zsh" "bat" "nvim" "alacritty" "karabiner"
    # ファイル単位 (同じディレクトリにアプリ自身が書くファイルがある)
    "starship.toml" "sheldon/plugins.toml" "zed/settings.json" "zed/keymap.json" "herdr/config.toml"
  ];
}
