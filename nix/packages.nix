{ pkgs, ... }:
{
  # CLI ツール (旧 Brewfile の formula) と言語ランタイム (旧 mise / nvm)
  home.packages = with pkgs; [
    # shell
    sheldon
    starship
    bat
    fd
    ripgrep
    tree
    watch
    wget
    htop
    gping
    httpie

    # dev
    neovim
    gh
    lazygit
    nb
    cmake
    gnumake
    clang-tools # clang-format

    # runtimes
    nodejs_latest
    python3
    lua
    perl
    ruby

    # 旧 Homebrew 直接インストール分 (Brewfile 外)
    eza
    glow
    helix
    aws-vault
    hunk
    treemd
    tuicr

    # JS / Python toolchain
    pnpm
    yarn
    deno
    uv

    # mobile / JVM
    ktlint
    ktfmt
    swiftformat
    scrcpy
    android-tools
    tuist
  ];
}
