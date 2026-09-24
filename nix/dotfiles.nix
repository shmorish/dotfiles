{ config, ... }:
let
  # stow の置き換え。Nix store にコピーせず、リポジトリ実体への symlink を張る。
  # nvim (lazy-lock.json) や karabiner (automatic_backups) の自己書き込みも従来どおり動く。
  # リポジトリ内のファイル編集は即反映。ファイル追加時だけ `make switch` が必要。
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

  # ~/ 直下に置くファイル (home/ 配下と同名)
  homeFiles = [
    ".zshrc"
    ".vimrc"
  ];

  # ~/.config/<name> をディレクトリごとリンク (中身はすべてリポジトリ管理)
  configDirs = [
    "zsh"
    "bat"
    "nvim"
    "wezterm"
    "karabiner"
  ];

  # ~/.config/<path> をファイル単位でリンク (同じディレクトリにアプリ自身が書くファイルがある)
  configFiles = [
    "starship.toml"
    "sheldon/plugins.toml"
    "zed/settings.json"
    "zed/keymap.json"
    "herdr/config.toml"
  ];

  mkLinks = prefix: names: builtins.listToAttrs (map (n: { name = n; value = { source = link "${prefix}/${n}"; }; }) names);
in
{
  home.file = mkLinks "home" homeFiles;
  xdg.configFile = mkLinks "config" (configDirs ++ configFiles);
}
