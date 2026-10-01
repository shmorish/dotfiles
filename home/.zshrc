# ---------------------------------- #
# My Configurations
# ---------------------------------- #

# Nix / Home Manager
# - /etc/zshrc への追記は macOS アップデートで消えることがあるので自分で読む
# - nix-daemon.sh はループ変数 i をグローバルに使うため、無名関数内で local にして隔離する
#   (外側で i が integer 型だとスクリプトが落ちる。外側の i には触れない)
() {
  local i
  [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] && . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
}
# 親シェルで読み込み済み扱い (__ETC_PROFILE_NIX_SOURCED) の子シェルでも PATH を保証する。
# path は typeset -U で重複が自動除去されるので何度通っても増えない。
typeset -U path
path=("$HOME/.nix-profile/bin" /nix/var/nix/profiles/default/bin $path)
[ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# sheldon
eval "$(sheldon source)"
source <(fzf --zsh)

for f in "$HOME"/.config/zsh/config/*.zsh; do source "$f"; done

# starship
eval "$(starship init zsh)"

# OpenSpec
export OPENSPEC_TELEMETRY=0

export PATH=$PATH:$HOME/.maestro/bin

# direnv (プロンプトを変更するものより後に置く)
command -v direnv >/dev/null && eval "$(direnv hook zsh)"
