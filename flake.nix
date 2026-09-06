{
  description = "sh-morishita dotfiles (Home Manager standalone)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # wezterm nightly (公式 flake)。main ブランチをビルドする。
    # macOS 向けのバイナリキャッシュは無いのでローカルでソースビルドになる。
    # 更新は `nix flake update wezterm` で明示的に行う。
    wezterm.url = "github:wezterm/wezterm?dir=nix";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "aarch64-darwin";
      username = "sh-morishita";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # claude-code, github-copilot-cli
      };
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs username; };
        modules = [ ./nix ];
      };
    };
}
