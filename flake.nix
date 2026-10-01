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

      # プロジェクトごとの Node 切り替え用。各プロジェクトの .envrc に
      #   use flake ~/dotfiles#node22
      # と書くと direnv がそのディレクトリだけ PATH を差し替える。
      devShells.${system} =
        let
          nodeShell = nodejs: pkgs.mkShell {
            packages = [ nodejs pkgs.pnpm pkgs.yarn ];
          };
        in
        {
          node22 = nodeShell pkgs.nodejs_22;
          node24 = nodeShell pkgs.nodejs_24;
          node26 = nodeShell pkgs.nodejs_26;
        };
    };
}
