# DOTFILES

個人的な設定ファイル群を管理するためのリポジトリです。
Nix + Home Manager (standalone) で管理しています。

## 前提

- Apple Silicon Mac (aarch64-darwin)
- 管理者権限 (Nix のインストールに sudo が必要)
- このリポジトリを `~/dotfiles` に clone していること

## インストール方法

```bash
cd ~/dotfiles
make setup
```

`make setup` は次を行います。

1. Nix が無ければ [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) でインストール
2. `home-manager switch --flake ~/dotfiles` で設定ファイルの symlink とパッケージを適用

初回は wezterm (nightly) をソースからビルドするため時間がかかります。

## 設定を変更したとき

```bash
make switch   # または zsh 上で hms
```

## 依存パッケージの更新

```bash
nix flake update nixpkgs home-manager   # 通常はこちら
nix flake update wezterm                # wezterm を更新したいときだけ (再ビルドが走る)
make switch
```

## アンインストール方法

```bash
cd ~/dotfiles
make clean          # Home Manager の symlink とプロファイルを外す (Nix は残る)
make nix-uninstall  # Nix 本体を完全に削除する (端末返却時など)
```

## 構成

```
flake.nix        # inputs (nixpkgs, home-manager, wezterm) と homeConfigurations
nix/             # Home Manager モジュール
  default.nix    #   ユーザー情報、stateVersion
  packages.nix   #   CLI ツールとランタイム
  apps.nix       #   GUI アプリとフォント
  java.nix       #   JDK (21 が既定、8 は ~/.jdks/zulu-8)
  dotfiles.nix   #   home/ と config/ を ~/ と ~/.config/ へリンク
  gc.nix         #   週次のガベージコレクション
home/            # ~/ 直下に置くファイル (.zshrc, .gitconfig, .vimrc)
config/          # ~/.config/ 配下 (zsh, nvim, wezterm, karabiner, zed, herdr, ...)
.bin/            # セットアップスクリプト
```

設定ファイルは Nix store にコピーせず、リポジトリ実体への symlink として配置されます。
そのためリポジトリ内のファイルを直接編集すれば即反映されます (新規ファイルの追加時のみ `make switch` が必要)。
