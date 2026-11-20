{ config, lib, pkgs, link, ... }:
let
  # Vault のノートは別の Git repo (shmorish/obsidian) で管理し、その .gitignore で .obsidian/ を外している
  vault = "${config.home.homeDirectory}/Private/obsidian/.obsidian";
  # 自作のプラグインとテーマ。obsidian-toolkit の CI が変換して Release に置いたものを取ってくる（ここではビルドしない）。
  # 変えたらそちらで manifest.json の version を上げて push し（CI がタグと Release を作る）、ここの URL のタグと hash を上げる
  toolkit = pkgs.fetchzip {
    url = "https://github.com/shmorish/obsidian-toolkit/releases/download/v0.6.0/obsidian-toolkit.tar.gz";
    hash = "sha256-8QTDico5dhSU/MY/dw7EhOxf3HhL6rRl3fgKuTn4UDM=";
    stripRoot = false;
  };
  # community プラグインの Tasks。自作するには重いので、リリースにあるビルド済みファイルをバージョン固定で取ってくる。
  # 有効にするため obsidian/community-plugins.json にも id を書いている。
  # 今は日本語訳を足した fork（8.6.0 + 日本語訳）を使っている。本家に日本語訳が入った版が出たら、本家の repo とその版に戻す
  tasks = pkgs.linkFarm "obsidian-tasks-plugin" (lib.mapAttrsToList (name: hash: {
    inherit name;
    path = pkgs.fetchurl { url = "https://github.com/shmorish/obsidian-tasks/releases/download/8.6.0-ja.1/${name}"; inherit hash; };
  }) {
    "main.js" = "sha256-IbOdoSQkEhm1ivbTbDyJCcUkVqGsKdk1EDhi1XvWBNk=";
    "manifest.json" = "sha256-LvyI356XMkc2DUhrQgeRwmbIgkUWkZMDuUjQGS4VkSc=";
    "styles.css" = "sha256-1w2OvUH8I7/V1Zhzsak+2VVLFUVGo+Y3vU4ELmLRzyM=";
  });
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
    run mkdir -p "${vault}/plugins/obsidian-tasks-plugin"
    run ${pkgs.coreutils}/bin/cp -L --no-preserve=mode ${tasks}/* "${vault}/plugins/obsidian-tasks-plugin/"
  '';
}
