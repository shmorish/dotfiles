{ pkgs, ... }:
let
  # nixpkgs 未収録。Mermaid 描画と PDF 出力は Chrome を実行時に使う
  glowm = pkgs.buildGoModule rec {
    pname = "glowm";
    version = "0.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "atani";
      repo = "glowm";
      rev = "v${version}";
      hash = "sha256-kyylQrn2OROQe+taGEw0L7q5Y6HW+UqDcA46DOgeOYI=";
    };
    vendorHash = "sha256-9Wg6WvXJWS1NTJsXFAMsIHTaeDzVzmdzuqS+uksJ2Ig=";
    subPackages = [ "cmd/glowm" ];
    ldflags = [ "-s" "-w" "-X main.version=${version}" ];
  };
in
{
  home.packages = with pkgs; [
    # shell
    sheldon starship fzf bat eza fd ripgrep jq tree watch wget htop gping httpie glowm
    terminal-notifier # Herdr の通知（押すと Herdr が前に出る）
    # dev
    neovim helix gh lazygit hunk treemd tuicr nb herdr awscli2 aws-vault devcontainer cmake gnumake clang-tools
    # runtimes / toolchains (プロジェクト別の node は flake.nix の devShells)
    nodejs_latest pnpm yarn deno python3 uv lua perl ruby
    # mobile / JVM
    ktlint ktfmt swiftformat scrcpy android-tools tuist
    # GUI / font。.app は ~/Applications/Home Manager Apps、font は ~/Library/Fonts/HomeManager に HM が配置
    alacritty bruno vscode herdr-desktop obsidian claude-code github-copilot-cli nerd-fonts.hack
  ];
}
