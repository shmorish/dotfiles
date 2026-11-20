{ lib, link, ... }:
let
  # Vault のノートは別の Git repo (shmorish/obsidian) で管理し、その .gitignore で .obsidian/ を外している
  vault = "Private/obsidian";
in
{
  # Vault の設定は repo 実体へ symlink。Obsidian は symlink 越しに書くので、画面で変えた設定はそのまま repo に入る
  # (HM の programs.obsidian は store への読み取り専用リンクになり、変更が黙って捨てられる)。
  # workspace.json などの開いているタブや表示状態は管理しない
  home.file = lib.mapAttrs' (n: v: lib.nameValuePair "${vault}/.obsidian/${n}" v) (link "obsidian" [
    "app.json" "appearance.json" "core-plugins.json" "hotkeys.json" "community-plugins.json"
    "templates.json" "daily-notes.json" "types.json"
    # 自作テーマ。Obsidian が書き換えないのでディレクトリごと symlink
    "themes/Mono"
  ]);
}
