{ config, lib, ... }:
let
  # stow の置き換え。store にコピーせずリポジトリ実体へ symlink するので、
  # nvim (lazy-lock.json) などの自己書き込みも動き、編集は即反映 (ファイル追加時だけ `make switch`)。
  link = prefix: names: lib.genAttrs names (n: {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${prefix}/${n}";
  });
  # config/herdr-app/<sub>/ にある自作の mod・layout を全部 (git add したものだけ見える)
  herdrApp = sub: map (n: "herdr-app/${sub}/${n}") (builtins.attrNames (builtins.readDir ../config/herdr-app/${sub}));
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
  ] ++ herdrApp "mods" ++ herdrApp "layouts");
}
