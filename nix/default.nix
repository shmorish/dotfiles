{ username, ... }:
{
  imports = [ ./packages.nix ./dotfiles.nix ./git.nix ./java.nix ];

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
