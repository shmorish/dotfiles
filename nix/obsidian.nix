{ config, lib, pkgs, link, ... }:
let
  # Vault のノートは別の Git repo (shmorish/obsidian) で管理し、その .gitignore で .obsidian/ を外している
  vault = "${config.home.homeDirectory}/Private/obsidian/.obsidian";
  # 自作のプラグインとテーマ。obsidian-toolkit の CI が変換して Release に置いたものを取ってくる（ここではビルドしない）。
  # 変えたらそちらで manifest.json の version を上げて push し（CI がタグと Release を作る）、ここの URL のタグと hash を上げる
  toolkit = pkgs.fetchzip {
    url = "https://github.com/shmorish/obsidian-toolkit/releases/download/v0.1.0/obsidian-toolkit.tar.gz";
    hash = "sha256-vNFDOIMkJ1yeaa9EqosoSQK25DOLhDzB01Oerb9mJTE=";
    stripRoot = false;
  };
in
{
  # Vault の設定は repo 実体へ symlink。Obsidian は symlink 越しに書くので、画面で変えた設定はそのまま repo に入る
  # (HM の programs.obsidian は store への読み取り専用リンクになり、変更が黙って捨てられる)。
  # workspace.json などの開いているタブや表示状態は管理しない
  home.file = lib.mapAttrs' (n: v: lib.nameValuePair "Private/obsidian/.obsidian/${n}" v) (link "obsidian" [
    "app.json" "appearance.json" "core-plugins.json" "hotkeys.json" "community-plugins.json"
    "templates.json" "daily-notes.json" "types.json"
  ]);

  # プラグインとテーマは実ファイルでコピーする（make dev で手元のビルドを上書きして試せるように）。
  # プラグインのフォルダは消さないので、Obsidian が書く data.json は残る。前の世代の symlink が消えてから置くので linkGeneration の後
  home.activation.obsidianToolkit = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run mkdir -p "${vault}/plugins/toolkit" "${vault}/themes"
    run ${pkgs.coreutils}/bin/cp --no-preserve=mode ${toolkit}/plugin/* "${vault}/plugins/toolkit/"
    run rm -rf "${vault}/themes/Mono"
    run ${pkgs.coreutils}/bin/cp -R --no-preserve=mode ${toolkit}/themes/Mono "${vault}/themes/"
  '';
}
