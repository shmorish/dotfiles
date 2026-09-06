# ---------------------------------- #
# My Configurations
# ---------------------------------- #

# Nix / Home Manager
# - /etc/zshrc への追記は macOS アップデートで消えることがあるので自分で読む
# - integer 型の変数 i が残っていると nix-daemon.sh 内の for ループが落ちるので先に unset
# - 親シェルで読み込み済み扱い (__ETC_PROFILE_NIX_SOURCED) の子シェルでも PATH は保証する
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  unset i
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
case ":$PATH:" in
  *":$HOME/.nix-profile/bin:"*) ;;
  *) export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH" ;;
esac
[ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# bun completions
[ -s "/Users/sh-morishita/.bun/_bun" ] && source "/Users/sh-morishita/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# sheldon
eval "$(sheldon source)"

source $HOME/.config/zsh/init.zsh

# starship
eval "$(starship init zsh)"

# OpenSpec
export OPENSPEC_TELEMETRY=0

export PATH=$PATH:$HOME/.maestro/bin
