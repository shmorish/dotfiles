{ config, ... }:
let
  # stow の置き換え。リポジトリ実体への symlink を張るので、
  # nvim (lazy-lock.json) や karabiner (automatic_backups) の自己書き込みも従来どおり動く。
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.file = {
    ".zshrc".source = link "zsh/.zshrc";
    ".vimrc".source = link "vim/.vimrc";
    ".gitconfig".source = link "git/.gitconfig";
  };

  xdg.configFile = {
    # ディレクトリごとリンク (中身はすべてリポジトリ管理)
    "zsh".source = link "zsh/.config/zsh";
    "bat".source = link "zsh/.config/bat";
    "nvim".source = link "nvim/.config/nvim";
    "wezterm".source = link "wezterm/.config/wezterm";
    "karabiner".source = link "karabiner/.config/karabiner";

    # ファイル単位でリンク (同じディレクトリにアプリ自身が書くファイルがある)
    "starship.toml".source = link "zsh/.config/starship.toml";
    "sheldon/plugins.toml".source = link "zsh/.config/sheldon/plugins.toml";
    "git/ignore".source = link "git/.config/git/ignore";
    "zed/settings.json".source = link "zed/.config/zed/settings.json";
    "zed/keymap.json".source = link "zed/.config/zed/keymap.json";
    "herdr/config.toml".source = link "herdr/.config/herdr/config.toml";
  };
}
