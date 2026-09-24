{ pkgs, ... }:
{
  # 旧 home/.gitconfig と config/git/ignore の置き換え。
  # 出力先は ~/.config/git/config と ~/.config/git/ignore (Home Manager が生成)。
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "shmorish";
        email = "110565242+shmorish@users.noreply.github.com";
      };

      core.editor = "vim";

      # PATH に依存せず Nix の hunk を直接参照する
      pager = {
        diff = "${pkgs.hunk}/bin/hunk pager";
        show = "${pkgs.hunk}/bin/hunk pager";
      };

      alias = {
        graph = "log --all --graph --oneline";
        tree = "log --graph --all --format=\"%x09%C(cyan bold)%an%Creset%x09%C(yellow)%h%Creset %C(magenta reverse)%d%Creset %s\"";
        open = "!gh repo view --web";
        open-pr = "!gh pr view --web";
        pr = "!gh pr list";
        issue = "!gh issue list";
      };
    };

    ignores = [
      ".claude/"
      ".idea/"
      ".vscode/"
      ".DS_Store"
      "**/.claude/settings.local.json"
      "**/.claude/settings.json"
    ];
  };
}
