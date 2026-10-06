{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # shell
    sheldon starship fzf bat eza fd ripgrep jq tree watch wget htop gping httpie glow
    # dev
    neovim helix gh lazygit hunk treemd tuicr nb herdr awscli2 aws-vault devcontainer cmake gnumake clang-tools
    # runtimes / toolchains (プロジェクト別の node は flake.nix の devShells)
    nodejs_latest pnpm yarn deno python3 uv lua perl ruby
    # mobile / JVM
    ktlint ktfmt swiftformat scrcpy android-tools tuist
    # GUI / font。.app は ~/Applications/Home Manager Apps、font は ~/Library/Fonts/HomeManager に HM が配置
    alacritty postman claude-code github-copilot-cli nerd-fonts.hack
  ];
}
