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
    (plugin "obsidian-advanced-uri" "vinzent03/obsidian-advanced-uri" "2.2.1" {
      "main.js" = "sha256-hVXZpU3g1VNABwR6weWN7nRvOU+eI/5XQMpYV4Ukd/M=";
      "manifest.json" = "sha256-BVeVeUdzzMlSaIywGyS/nDKczyNzHC/47Jg1Uz4Ms4s=";
      "styles.css" = "sha256-8wKoLxNavlC8u1ZSPL6Xq0BSkKQ1hYIbjlLfTt5PRBc=";
    })
    (plugin "obsidian-book-search-plugin" "anpigon/obsidian-book-search-plugin" "0.7.5" {
      "main.js" = "sha256-H0wByq1CvMz9IriNjkArBnSPuG2LyNpj3auENwBq53k=";
      "manifest.json" = "sha256-X63gI+w1iv+3ESVb5ZKkS0QsSCQ0Ew9UHyBA4JdPHDc=";
      "styles.css" = "sha256-aoYzu0ZVtIwhyjy6RJmFyJSwTL8vWhnEmuBzu229oOU=";
    })
    (plugin "callout-manager" "eth-p/obsidian-callout-manager" "1.1.2" {
      "main.js" = "sha256-PJfroN0Mfni/P6rXAcu8ODR1QmS88HF69kQD/hUrLwQ=";
      "manifest.json" = "sha256-sOAiQseLOeEmPaiR14nj/KoMH2xIqhwrvkuJLdyMzgo=";
      "styles.css" = "sha256-hd19ATrWQvz2zJ+9h6ga1wdpJ2xHJXIlYuNYX0QHqlQ=";
    })
    (plugin "obsidian-excalidraw-plugin" "zsviczian/obsidian-excalidraw-plugin" "2.29.2" {
      "main.js" = "sha256-Sd/FZnp3MNvBJM38KkqOiRiBAGNkk6OdZJO/VpalVUE=";
      "manifest.json" = "sha256-joKCj9kSVhXoo2HQ8VVT5UjKwu56MD5VOHN4pTuSX9k=";
      "styles.css" = "sha256-bHqZFPgzBdCfmVckiJf/LyXPLC1LRrLZq0Lzx+4dKfA=";
    })
    (plugin "journal-review" "kageetai/obsidian-plugin-journal-review" "4.0.0" {
      "main.js" = "sha256-DrbAzoVTppUjHLxBpfryERtrFr09BLVv6pxIky2udrY=";
      "manifest.json" = "sha256-ltAmkILAmTfFt77oH8xPdfp9og93KUNGaQLDehPvebU=";
      "styles.css" = "sha256-0Knr3IzPv2bv/EA+Dn5Pzw9otK7934Y/7sdC1/pyoMQ=";
    })
    (plugin "obsidian-kindle-plugin" "hadynz/obsidian-kindle-plugin" "2.3.1" {
      "main.js" = "sha256-k9OD8dk2AiI6V7pKn3Ztjwz0j6AQmtPE7ZiUeZ5xX2E=";
      "manifest.json" = "sha256-tj1Cu8qSWN+QYWARzIqI8wD3a/6HUrOJUDD/E8AnHfs=";
    })
    (plugin "mermaid-tools" "dartungar/obsidian-mermaid" "1.4.3" {
      "main.js" = "sha256-Sg1aLB0nlYc2p6VnInJw4tcn4rUvrphb7dEyskHnt1w=";
      "manifest.json" = "sha256-45LYJwhSGkr/waIh0+OqFv9/bpEWKQZA3QkhOTYIiMk=";
      "styles.css" = "sha256-XUivyfLM7/1ri6pV/uUab943TjAZWHDqUsXax5OkQkI=";
    })
    (plugin "mononote" "czottmann/obsidian-mononote" "1.2.2" {
      "main.js" = "sha256-JoW8mA8ffwasLsKGIoD2nbA/s2hAufwNRgGAkVQLCCI=";
      "manifest.json" = "sha256-df8Ant3tCqwcEedXGuU7nHX1o2rzJGeE4tHrdxYKqLc=";
    })
    (plugin "darlal-switcher-plus" "darlal/obsidian-switcher-plus" "6.3.0" {
      "main.js" = "sha256-Z0ba09axMmmLBMKhDqDC9xwDyLWve+x1PKdjGccuPyM=";
      "manifest.json" = "sha256-H1qyAXUuwKavY1P24E1qV8vZhRx+qeOl1Kt/UuCFjtY=";
      "styles.css" = "sha256-T4XeOpAreMZJEPycvAfRvEV7tdrbUds1S0BfIdxnvDY=";
    })
    (plugin "recent-files-obsidian" "tgrosinger/recent-files-obsidian" "1.7.10" {
      "main.js" = "sha256-moXSKjQta8jPy/6JqO0Ezf20RMNwoiCwCORCPx/Tfcg=";
      "manifest.json" = "sha256-bb+jFKS13z9/goP9Qbxk0Um+88ESjhW1qU3GkLVfsNc=";
      "styles.css" = "sha256-LuSckqsLuEgiGglib3umdrvoU3LEyAZe53kLCDLLPds=";
    })
    (plugin "obsidian-style-settings" "obsidian-community/obsidian-style-settings" "1.0.9" {
      "main.js" = "sha256-GCirqs2rTFV4twWmJcWFswUS+O+tTHz8WhjnDMNVdGg=";
      "manifest.json" = "sha256-nP/cIM8qoTVIIOAFC2lLD5tXZEbj1dRKNq6LAYflv7g=";
      "styles.css" = "sha256-7nk30r5QZTqJzLMK5fBXKyNQfVt/EyjQBScaNjB1v9g=";
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
