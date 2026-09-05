# ---------------------------------- #
# My Configurations
# ---------------------------------- #

# Nix / Home Manager
# /etc/zshrc への追記は macOS アップデートで消えることがあるので自分で読む
[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] && . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
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
