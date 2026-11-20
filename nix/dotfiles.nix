{ config, lib, pkgs, ... }:
let
  # stow の置き換え。store にコピーせずリポジトリ実体へ symlink するので、
  # nvim (lazy-lock.json) などの自己書き込みも動き、編集は即反映 (ファイル追加時だけ `make switch`)。
  link = prefix: names: lib.genAttrs names (n: {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${prefix}/${n}";
  });
  # config/herdr-app/<sub>/ にある自作の mod・layout を全部 (git add したものだけ見える)
  herdrApp = sub: map (n: "herdr-app/${sub}/${n}") (builtins.attrNames (builtins.readDir ../config/herdr-app/${sub}));
  # コミュニティの Herdr mod。LICENSE が無いので repo にはコピーせず、コミット固定で取ってくる。
  # 自分の fork (kamikuo/herdr-moe-office から)。作業役の二重表示・帰るときのワープ・レイアウトの props が効かない問題の修正と、Ocean の部屋を足してある
  moeOffice = pkgs.fetchFromGitHub {
    owner = "shmorish";
    repo = "herdr-moe-office";
    rev = "77fa9ffdb9e0156d49367ba46862ecaa935b7d67";
    hash = "sha256-ZcOm1FWrdNW1R66+QWO4xtdlpyvz7LWZYhPsFL9dn50=";
  };
  # コミュニティの Herdr レイアウト (MIT)。scripts/install.sh と同じものを置く
  herdrGlass = pkgs.fetchFromGitHub {
    owner = "noah4520";
    repo = "herdr-glass";
    rev = "bbea46299dd02d1ab3a07b3a154ad5153ebb06b4";
    hash = "sha256-58x8sPfocOaM0uB71TXbyEHLXClMlC0RqY4sHax9aVI=";
  };
  # Obsidian の community プラグイン。作者のリリースにあるビルド済みファイルをバージョン固定で取ってくる。
  # 有効にするものは obsidian/community-plugins.json に id を足す
  # Vault のノートは別の Git repo (shmorish/obsidian) で管理し、その .gitignore で .obsidian/ を外している
  vault = "Private/obsidian";
  obsidianPlugin = id: repo: version: hashes: pkgs.linkFarm id (lib.mapAttrsToList (f: hash: {
    name = f;
    path = pkgs.fetchurl { url = "https://github.com/${repo}/releases/download/${version}/${f}"; inherit hash; };
  }) hashes);
  obsidianPlugins = [
    (obsidianPlugin "obsidian-auto-link-title" "zolrath/obsidian-auto-link-title" "1.5.5" {
      "main.js" = "sha256-6ydJi/0F3Fw4R90HL1Ve1MAq7OJEUQQsLtsl/JYfOL4=";
      "manifest.json" = "sha256-IZFsjI+hmW04/HnmBkth9BxrNNXU6t2vNvGEMrP0mhE=";
      "styles.css" = "sha256-BA2Zx4es+Q26Q3TCG2dBfd5DrMWe1KubzuUQv7xFCLI=";
    })
    (obsidianPlugin "obsidian-git" "vinzent03/obsidian-git" "2.43.0" {
      "main.js" = "sha256-WL6wmBh1xnL8gzUOOx8g22yh3zyiBHol9JGQseMeJEM=";
      "manifest.json" = "sha256-TzRQ8yAfAuLh6L8qhzC/yDfPQqJduZG7XZMFbRcJOVE=";
      "styles.css" = "sha256-kq6A0mAOW8dkPdq8qjfYiOEul2Pv/2PcqVzJSkQhB4E=";
    })
    (obsidianPlugin "calendar" "liamcain/obsidian-calendar-plugin" "1.5.10" {
      "main.js" = "sha256-f7M56c+f2+WoAforirhbNmtbN3f70ZPLyHKLwncR0SU=";
      "manifest.json" = "sha256-8+lYEzhkhRK6oS1bRYSQ9/02eRj3vba9hhcc5Xvn0Is=";
    })
    (obsidianPlugin "templater-obsidian" "silentvoid13/Templater" "2.27.0" {
      "main.js" = "sha256-C0oi56OHH5KeGGVtnzx979hYjJ3FhFYguaFuCtt8mi8=";
      "manifest.json" = "sha256-qdEN9Ee5zmDnLfd1zqZvJG2sqsHy5QiwI1hVUvCL6QA=";
      "styles.css" = "sha256-Z6bdLR1t7coSh8M0yohOxBlkM/ccpHOIoL0+rBTPi18=";
    })
    (obsidianPlugin "dataview" "blacksmithgu/obsidian-dataview" "0.5.68" {
      "main.js" = "sha256-eU6ert5zkgu41UsO2k9d4hgtaYzGOHdFAPJPFLzU2gs=";
      "manifest.json" = "sha256-kjXbRxEtqBuFWRx57LmuJXTl5yIHBW6XZHL5BhYoYYU=";
      "styles.css" = "sha256-MwbdkDLgD5ibpyM6N/0lW8TT9DQM7mYXYulS8/aqHek=";
    })
    (obsidianPlugin "obsidian-tasks-plugin" "obsidian-tasks-group/obsidian-tasks" "8.6.0" {
      "main.js" = "sha256-UA+BBtBd20g7v+wTXKx5SAIr9rpzhtGFGyj00IeGbo8=";
      "manifest.json" = "sha256-LvyI356XMkc2DUhrQgeRwmbIgkUWkZMDuUjQGS4VkSc=";
      "styles.css" = "sha256-1w2OvUH8I7/V1Zhzsak+2VVLFUVGo+Y3vU4ELmLRzyM=";
    })
  ];
in
{
  home.file = link "home" [ ".zshrc" ".vimrc" ]
    # 自作の Claude Code skill。グローバル gitignore が .claude/ を無視するので repo 側はドットなし
    // lib.mapAttrs' (n: v: lib.nameValuePair ".claude/${n}" v) (link "claude" [ "skills/herdr-lead" "statusline.sh" ])
    # Obsidian の Vault 設定。Obsidian は symlink 越しに書くので、画面で変えた設定もそのまま repo に入る
    # (HM の programs.obsidian は store への読み取り専用リンクになり、変更が黙って捨てられる)。
    # workspace.json などの開いているタブや表示状態は管理しない
    # プラグインの設定 (data.json) も、プラグインが自分で書くので同じく repo 実体へ symlink
    // lib.mapAttrs' (n: v: lib.nameValuePair "${vault}/.obsidian/${n}" v)
      (link "obsidian" [
        "app.json" "appearance.json" "core-plugins.json" "hotkeys.json" "community-plugins.json"
        "templates.json" "daily-notes.json" "types.json"
        "plugins/calendar/data.json" "plugins/obsidian-git/data.json" "plugins/templater-obsidian/data.json"
      ]);
  # プラグイン本体は実ファイルでコピーする（store への symlink だと Obsidian の更新で書き込めない）。
  # フォルダごと消さないので、data.json や obsidian-git が作る obsidian_askpass.sh は残る
  home.activation.obsidianPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.concatMapStrings (p: ''
    run mkdir -p "$HOME/${vault}/.obsidian/plugins/${p.name}"
    run ${pkgs.coreutils}/bin/cp -L --no-preserve=mode ${p}/* "$HOME/${vault}/.obsidian/plugins/${p.name}/"
  '') obsidianPlugins);
  xdg.configFile = link "config" ([
    # ディレクトリごと
    "zsh" "bat" "nvim" "alacritty"
    # ファイル単位 (同じディレクトリにアプリ自身が書くファイルがある)
    "starship.toml" "sheldon/plugins.toml" "herdr/config.toml"
    # Herdr.app: 同梱の layouts/mods/themes は起動時に Herdr が上書きするので、自作分だけ足す
    "herdr-app/settings.json" "herdr-app/keys.json"
  ] ++ herdrApp "mods" ++ herdrApp "layouts"
    # 自作・取り込んだテーマ（.json だけ。ライセンス表記は repo にだけ置く）
    ++ builtins.filter (lib.hasSuffix ".json") (herdrApp "themes"));
  # Herdr は symlink 越しの画像を読まないので、moe-office は実ファイルとしてコピーする
  home.activation.herdrMoeOffice = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dest="${config.xdg.configHome}/herdr-app/mods/moe-office"
    run rm -rf "$dest"
    run ${pkgs.coreutils}/bin/cp -R --no-preserve=mode "${moeOffice}/mods/moe-office" "$dest"
  '';
  # Herdr Glass も実ファイルでコピーする（Appearance がレイアウトに書き込み、背景画像も symlink 越しだと読めない）
  home.activation.herdrGlass = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    h="${config.xdg.configHome}/herdr-app"
    run mkdir -p "$h/layouts" "$h/themes" "$h/mods"
    for m in ${herdrGlass}/mods/herdr-glass-*; do
      run rm -rf "$h/mods/$(basename "$m")"
      run ${pkgs.coreutils}/bin/cp -R --no-preserve=mode "$m" "$h/mods/"
    done
    run ${pkgs.coreutils}/bin/cp --no-preserve=mode ${herdrGlass}/themes/herdr-glass.json "$h/themes/"
    run ${pkgs.coreutils}/bin/cp --no-preserve=mode ${herdrGlass}/layouts/herdr-glass.svg "$h/layouts/"
    # レイアウトは Appearance の選択を保存しているので、無いときだけ置く
    [ -e "$h/layouts/herdr-glass.json" ] || run ${pkgs.coreutils}/bin/cp --no-preserve=mode ${herdrGlass}/layouts/herdr-glass.json "$h/layouts/"
  '';
}
