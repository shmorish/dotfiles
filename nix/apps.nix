{ pkgs, inputs, ... }:
{
  # GUI アプリとフォント (旧 Brewfile の cask)
  # - .app は targets.darwin.copyApps (stateVersion >= 25.11 で既定 on) により
  #   ~/Applications/Home Manager Apps/ へコピーされる
  # - フォントは Home Manager が ~/Library/Fonts/HomeManager/ へ自動コピーする
  home.packages = [
    inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.claude-code
    pkgs.github-copilot-cli
    pkgs.hackgen-nf-font
  ];
}
