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
3. `com.apple.rcd` を無効化 (メディアキーで Music.app が起動しないようにする)
4. キーボード設定 (`make macos-keys`): fn キーを標準に、Option+L で画面ロック、F3 で選択範囲をクリップボードへスクショ


## 設定を変更したとき

```bash
make switch   # または zsh 上で hms
```

## 依存パッケージの更新

```bash
nix flake update
make switch
```

## プロジェクトごとの Node 切り替え

`flake.nix` の `devShells` に `node22` / `node24` / `node26` を定義しています。
プロジェクトのルートに `.envrc` を置くと、そのディレクトリに入ったときだけ direnv が PATH を差し替えます。

```bash
cd ~/Work/some-project
echo 'use flake ~/dotfiles#node22' > .envrc
direnv allow
node --version   # v22.x
```

`.envrc` と `.direnv/` はグローバルの gitignore で無視されるので、リポジトリには残りません。
その場限りで試すだけなら `nix shell nixpkgs#nodejs_22` でも切り替えられます。

## アンインストール方法

```bash
cd ~/dotfiles
make clean          # Home Manager の symlink とプロファイルを外す (Nix は残る)
make nix-uninstall  # Nix 本体を完全に削除する (端末返却時など)
```

## 構成

```
flake.nix        # inputs (nixpkgs, home-manager) と homeConfigurations
nix/             # Home Manager モジュール
  default.nix    #   ユーザー情報、direnv、週次 GC
  packages.nix   #   CLI / GUI / font のパッケージ一覧
  java.nix       #   JDK (21 が既定、8 は ~/.jdks/zulu-8)
  git.nix        #   git の設定 (~/.config/git/config, ignore を生成)
  dotfiles.nix   #   home/ と config/ を ~/ と ~/.config/ へリンク
home/            # ~/ 直下に置くファイル (.zshrc, .vimrc)
config/          # ~/.config/ 配下 (zsh, nvim, alacritty, zed, herdr, ...)。git は git.nix で生成
Makefile         # setup / switch / clean / nix-uninstall
```

設定ファイルは Nix store にコピーせず、リポジトリ実体への symlink として配置されます。
そのためリポジトリ内のファイルを直接編集すれば即反映されます (新規ファイルの追加時のみ `make switch` が必要)。
