{ config, lib, username, ... }:
{
  imports = [ ./packages.nix ./dotfiles.nix ./git.nix ./java.nix ./herdr.nix ./obsidian.nix ];

  # stow の置き換え。store にコピーせずリポジトリ実体へ symlink するので、
  # nvim (lazy-lock.json) などの自己書き込みも動き、編集は即反映 (ファイル追加時だけ `make switch`)。
  _module.args.link = prefix: names: lib.genAttrs names (n: {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${prefix}/${n}";
  });

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "26.05"; # 初回導入時の HM リリース。変更しない

  programs.home-manager.enable = true;

  # /nix 肥大化対策。週次で 14 日より古い世代を回収
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
