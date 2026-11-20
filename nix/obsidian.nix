{ lib, pkgs, link, ... }:
let
  # Vault のノートは別の Git repo (shmorish/obsidian) で管理し、その .gitignore で .obsidian/ を外している
  vault = "Private/obsidian";
  # community プラグイン。作者のリリースにあるビルド済みファイルをバージョン固定で取ってくる。
  # 有効にするものは obsidian/community-plugins.json に id を足す
  plugin = id: repo: version: hashes: pkgs.linkFarm id (lib.mapAttrsToList (f: hash: {
    name = f;
    path = pkgs.fetchurl { url = "https://github.com/${repo}/releases/download/${version}/${f}"; inherit hash; };
  }) hashes);
  plugins = [
    (plugin "obsidian-auto-link-title" "zolrath/obsidian-auto-link-title" "1.5.5" {
      "main.js" = "sha256-6ydJi/0F3Fw4R90HL1Ve1MAq7OJEUQQsLtsl/JYfOL4=";
      "manifest.json" = "sha256-IZFsjI+hmW04/HnmBkth9BxrNNXU6t2vNvGEMrP0mhE=";
      "styles.css" = "sha256-BA2Zx4es+Q26Q3TCG2dBfd5DrMWe1KubzuUQv7xFCLI=";
    })
    (plugin "obsidian-git" "vinzent03/obsidian-git" "2.43.0" {
      "main.js" = "sha256-WL6wmBh1xnL8gzUOOx8g22yh3zyiBHol9JGQseMeJEM=";
      "manifest.json" = "sha256-TzRQ8yAfAuLh6L8qhzC/yDfPQqJduZG7XZMFbRcJOVE=";
      "styles.css" = "sha256-kq6A0mAOW8dkPdq8qjfYiOEul2Pv/2PcqVzJSkQhB4E=";
    })
    (plugin "calendar" "liamcain/obsidian-calendar-plugin" "1.5.10" {
      "main.js" = "sha256-f7M56c+f2+WoAforirhbNmtbN3f70ZPLyHKLwncR0SU=";
      "manifest.json" = "sha256-8+lYEzhkhRK6oS1bRYSQ9/02eRj3vba9hhcc5Xvn0Is=";
    })
    (plugin "templater-obsidian" "silentvoid13/Templater" "2.27.0" {
      "main.js" = "sha256-C0oi56OHH5KeGGVtnzx979hYjJ3FhFYguaFuCtt8mi8=";
      "manifest.json" = "sha256-qdEN9Ee5zmDnLfd1zqZvJG2sqsHy5QiwI1hVUvCL6QA=";
      "styles.css" = "sha256-Z6bdLR1t7coSh8M0yohOxBlkM/ccpHOIoL0+rBTPi18=";
    })
    (plugin "dataview" "blacksmithgu/obsidian-dataview" "0.5.68" {
      "main.js" = "sha256-eU6ert5zkgu41UsO2k9d4hgtaYzGOHdFAPJPFLzU2gs=";
      "manifest.json" = "sha256-kjXbRxEtqBuFWRx57LmuJXTl5yIHBW6XZHL5BhYoYYU=";
      "styles.css" = "sha256-MwbdkDLgD5ibpyM6N/0lW8TT9DQM7mYXYulS8/aqHek=";
    })
    (plugin "obsidian-tasks-plugin" "obsidian-tasks-group/obsidian-tasks" "8.6.0" {
      "main.js" = "sha256-UA+BBtBd20g7v+wTXKx5SAIr9rpzhtGFGyj00IeGbo8=";
      "manifest.json" = "sha256-LvyI356XMkc2DUhrQgeRwmbIgkUWkZMDuUjQGS4VkSc=";
      "styles.css" = "sha256-1w2OvUH8I7/V1Zhzsak+2VVLFUVGo+Y3vU4ELmLRzyM=";
    })
  ];
in
{
  # Vault の設定とプラグインの設定 (data.json) は repo 実体へ symlink。Obsidian もプラグインも symlink 越しに書くので、
  # 画面で変えた設定はそのまま repo に入る (HM の programs.obsidian は store への読み取り専用リンクになり、変更が黙って捨てられる)。
  # workspace.json などの開いているタブや表示状態は管理しない
  home.file = lib.mapAttrs' (n: v: lib.nameValuePair "${vault}/.obsidian/${n}" v) (link "obsidian" [
    "app.json" "appearance.json" "core-plugins.json" "hotkeys.json" "community-plugins.json"
    "templates.json" "daily-notes.json" "types.json"
    "plugins/calendar/data.json" "plugins/obsidian-git/data.json" "plugins/templater-obsidian/data.json"
  ]);

  # プラグイン本体は実ファイルでコピーする（store への symlink だと Obsidian の更新で書き込めない）。
  # フォルダごと消さないので、data.json や obsidian-git が作る obsidian_askpass.sh は残る
  home.activation.obsidianPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.concatMapStrings (p: ''
    run mkdir -p "$HOME/${vault}/.obsidian/plugins/${p.name}"
    run ${pkgs.coreutils}/bin/cp -L --no-preserve=mode ${p}/* "$HOME/${vault}/.obsidian/plugins/${p.name}/"
  '') plugins);
}
