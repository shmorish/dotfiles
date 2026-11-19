{ config, lib, pkgs, ... }:
let
  # stow の置き換え。store にコピーせずリポジトリ実体へ symlink するので、
  # nvim (lazy-lock.json) などの自己書き込みも動き、編集は即反映 (ファイル追加時だけ `make switch`)。
  link = prefix: names: lib.genAttrs names (n: {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${prefix}/${n}";
  });
  # config/herdr-app/<sub>/ にある自作の mod・layout を全部 (git add したものだけ見える)
  herdrApp = sub: map (n: "herdr-app/${sub}/${n}") (builtins.attrNames (builtins.readDir ../config/herdr-app/${sub}));
  # コミュニティの Herdr mod。LICENSE が無いので repo にはコピーせず、作者の repo をコミット固定で取ってくる
  moeOffice = pkgs.fetchFromGitHub {
    owner = "kamikuo";
    repo = "herdr-moe-office";
    rev = "e8018e1e753aabe621fc4fd095a7b9bf821446c1";
    hash = "sha256-/fOz/DNHRqjFb8UIueY3y7jjOE+opZHSg9s+RVZ9k5g=";
  };
in
{
  home.file = link "home" [ ".zshrc" ".vimrc" ]
    # 自作の Claude Code skill。グローバル gitignore が .claude/ を無視するので repo 側はドットなし
    // lib.mapAttrs' (n: v: lib.nameValuePair ".claude/${n}" v) (link "claude" [ "skills/herdr-lead" "statusline.sh" ]);
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
    # 生きている親がいるエージェント（herdr-lead の作業役など）は机を持たせず、親の横のインターンにだけする。
    # 自分の space を持つ作業役は agents() にも出るので、そのままだと机の子とインターンの二重になる
    run ${pkgs.gnused}/bin/sed -i 's|const list = agents();|const list = agents().filter((a) => { const ts = terminals(); const p = ts.find((k) => k.address === a.address)?.parent; return !ts.some((k) => k.address === p \&\& k.state === "live"); });|' "$dest/main.js"
    grep -q 'const list = agents().filter' "$dest/main.js" || echo "warning: moe-office の main.js が変わったため、作業役の二重表示の修正を当てられませんでした" >&2
    # 帰る子と配達員はドアや目的地にワープする。新しく作る要素を最初から目的地に置くので transition が効かない。
    # 最初の 1 フレームは出発点に描き、次のフレーム（描画は 110ms ごと）で目的地へ動かす。その分、消すのを少し待つ
    run ${pkgs.gnused}/bin/sed -i \
      -e 's|\.left(at\.x)\.top(at\.y - BOX \* g\.U)|.left(at.drawn ? at.x : (at.fromX ?? at.x)).top((at.drawn ? at.y : (at.fromY ?? at.y)) - BOX * g.U).map((el) => { at.drawn = true; return el; })|g' \
      -e 's|now >= at\.until) { delete this\.leaving|now >= at.until + 150) { delete this.leaving|' \
      -e 's|return \[box(dollSprite(k, "walk", -1, gr\.p, hash(k)), at\.x, at\.y)|return [box(dollSprite(k, "walk", -1, gr.p, hash(k)), at.drawn ? at.x : (at.fromX ?? at.x), at.drawn ? at.y : (at.fromY ?? at.y)).map((el) => { at.drawn = true; return el; })|' \
      -e 's|if (now >= at\.until \&\& at\.until > 0) { delete this\.grads\[k\];|if (now >= at.until + 150 \&\& at.until > 0) { delete this.grads[k];|' "$dest/main.js"
    # 仕事を終えたインターンも同じ（お辞儀の間は transition が無く、歩き出すフレームで付けても効かない）
    [ "$(grep -c 'at.drawn = true' "$dest/main.js")" = 3 ] || echo "warning: moe-office の main.js が変わったため、帰るときのワープの修正を当てられませんでした" >&2
  '';
}
