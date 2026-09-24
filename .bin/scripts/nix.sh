#!/bin/zsh

DOTFILES_DIR="$HOME/dotfiles"
NIX_INSTALLER="/nix/nix-installer"
NIX_DAEMON_SH="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

_source_nix() {
    [ -e "$NIX_DAEMON_SH" ] && . "$NIX_DAEMON_SH"
    [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
}

install_nix() {
    if [ -x "$NIX_INSTALLER" ]; then
        echo "Nix is already installed."
        return 0
    fi
    # Determinate installer: /nix/nix-installer と /nix/receipt.json が残り、
    # `/nix/nix-installer uninstall` で完全に元に戻せる (会社端末の返却時用)。
    curl --proto '=https' --tlsv1.2 -fsSL https://install.determinate.systems/nix | sh -s -- install
}

home_manager_switch() {
    _source_nix
    if ! command -v nix >/dev/null 2>&1; then
        echo "nix is not available. Run install_nix first (and open a new shell)."
        return 1
    fi
    if command -v home-manager >/dev/null 2>&1; then
        home-manager switch --flake "$DOTFILES_DIR" -b backup
    else
        # 初回のみ。以降は programs.home-manager.enable で CLI が入る。
        nix run home-manager -- switch --flake "$DOTFILES_DIR" -b backup
    fi
}

home_manager_uninstall() {
    _source_nix
    if command -v home-manager >/dev/null 2>&1; then
        home-manager uninstall
    else
        echo "home-manager is not installed."
    fi
}

uninstall_nix() {
    if [ -x "$NIX_INSTALLER" ]; then
        "$NIX_INSTALLER" uninstall
    else
        echo "Nix is not installed."
    fi
}
