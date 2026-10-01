# すべて ~/dotfiles を絶対パスで参照するので、どのディレクトリからでも実行できる。
DOTFILES := $(HOME)/dotfiles
# make は非対話シェルで動くため、Nix 直後のシェルでも PATH が通るよう毎回 source する。
NIX_SH := /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
NIX := [ -e $(NIX_SH) ] && . $(NIX_SH);
RCD := gui/$(shell id -u)/com.apple.rcd

.PHONY: help setup switch clean nix-uninstall

help:
	@echo "  setup          - Install Nix (Determinate) + home-manager switch + disable rcd"
	@echo "  switch         - Re-apply Home Manager configuration"
	@echo "  clean          - home-manager uninstall + re-enable rcd (keeps Nix)"
	@echo "  nix-uninstall  - /nix/nix-installer uninstall"

setup:
	@[ -x /nix/nix-installer ] || curl --proto '=https' --tlsv1.2 -fsSL https://install.determinate.systems/nix | sh -s -- install
	@$(MAKE) switch
	@launchctl disable $(RCD); launchctl kill SIGTERM $(RCD) 2>/dev/null || true
	@defaults write org.alacritty AppleFontSmoothing -int 0  # CoreText の太らせ描画を切る (WezTerm と同じ見え方)

switch:
	@$(NIX) nix run home-manager -- switch --flake $(DOTFILES) -b backup

clean:
	@$(NIX) nix run home-manager -- uninstall
	@launchctl enable $(RCD)

nix-uninstall:
	/nix/nix-installer uninstall
