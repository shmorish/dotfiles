{ config, lib, pkgs, link, ... }:
let
  # Vault のノートは別の Git repo (shmorish/obsidian) で管理し、その .gitignore で .obsidian/ を外している
  vault = "${config.home.homeDirectory}/Private/obsidian/.obsidian";
  # 自作のプラグインとテーマ。repo をコミット固定で取ってきて、その repo の build.sh で変換する。
  # 変えたらそちらに push し、ここの rev と hash を上げる
  toolkit = pkgs.runCommand "obsidian-toolkit" { nativeBuildInputs = [ pkgs.esbuild ]; } ''
    cd ${pkgs.fetchFromGitHub {
      owner = "shmorish";
      repo = "obsidian-toolkit";
      rev = "7d2bfdfe5f431bf75f2bb80c125e8f513f5e189e";
      hash = "sha256-WnYsnQeCciWxDTfTvelIpgTxn0/I9ig1ab7Wv5AEkVs=";
    }}
    sh ./build.sh $out
  '';
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
