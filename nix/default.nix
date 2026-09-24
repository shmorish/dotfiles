{ username, ... }:
{
  imports = [
    ./packages.nix
    ./apps.nix
    ./dotfiles.nix
    ./java.nix
    ./git.nix
    ./gc.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # 初回導入時の Home Manager リリース。挙動の互換性判定に使われるだけなので変更しない。
  home.stateVersion = "26.05";

  # home-manager CLI をプロファイルに入れる (`home-manager switch --flake ~/dotfiles`)
  programs.home-manager.enable = true;
}
