{ ... }:
{
  # /nix の肥大化対策。launchd agent (nix-gc) で週次 GC。
  # wezterm のソースビルドの残骸もここで回収される。
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
