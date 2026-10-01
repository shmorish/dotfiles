{ ... }:
{
  # プロジェクトごとの環境切り替え (.envrc の `use flake ~/dotfiles#node22` など)。
  # nix-direnv は評価結果をキャッシュし、GC からも保護するので 2 回目以降の cd が速い。
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
    # programs.zsh は使っていないので、hook は home/.zshrc に直接書いている
    enableZshIntegration = false;
  };
}
