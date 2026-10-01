{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # shell
    sheldon starship bat eza fd ripgrep tree watch wget htop gping httpie glow
    # dev
    neovim helix gh lazygit hunk treemd tuicr nb aws-vault cmake gnumake clang-tools
    # runtimes / toolchains (プロジェクト別の node は flake.nix の devShells)
    nodejs_latest pnpm yarn deno python3 uv lua perl ruby
    # mobile / JVM
    ktlint ktfmt swiftformat scrcpy android-tools tuist
    # GUI / font。.app は ~/Applications/Home Manager Apps、font は ~/Library/Fonts/HomeManager に HM が配置
    inputs.wezterm.packages.${stdenv.hostPlatform.system}.default
    claude-code github-copilot-cli hackgen-nf-font
  ];
}
