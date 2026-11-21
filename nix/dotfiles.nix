{ lib, link, ... }:
{
  home.file = link "home" [ ".zshrc" ".vimrc" ]
    # 自作の Claude Code skill。グローバル gitignore が .claude/ を無視するので repo 側はドットなし
    // lib.mapAttrs' (n: v: lib.nameValuePair ".claude/${n}" v) (link "claude" [ "skills/herdr-lead" "statusline.sh" ])
    # VS Code のユーザー設定
    // lib.mapAttrs' (n: v: lib.nameValuePair "Library/Application Support/Code/User/${n}" v) (link "vscode" [ "settings.json" ]);

  xdg.configFile = link "config" [
    # ディレクトリごと
    "zsh" "bat" "nvim" "alacritty"
    # ファイル単位 (同じディレクトリにアプリ自身が書くファイルがある)
    "starship.toml" "sheldon/plugins.toml" "herdr/config.toml"
  ];
}
