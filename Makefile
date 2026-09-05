help:
	@echo "Available targets:"
	@echo "  setup          - Install Nix (Determinate installer) and apply Home Manager"
	@echo "  switch         - Re-apply Home Manager configuration"
	@echo "  clean          - Remove Home Manager symlinks/profile (keeps Nix)"
	@echo "  nix-uninstall  - Completely remove Nix (/nix/nix-installer uninstall)"
	@echo "  help           - Show this help message"
.PHONY: help

define require_dotfiles_dir
	@if [ "$$(pwd)" != "${HOME}/dotfiles" ]; then \
		echo "Error: Please run from ${HOME}/dotfiles"; \
		exit 1; \
	fi
endef

setup:
	@echo "Setting up the environment..."
	$(require_dotfiles_dir)
	@zsh .bin/setup_mac.sh
.PHONY: setup

switch:
	$(require_dotfiles_dir)
	@zsh -c '. .bin/scripts/nix.sh && home_manager_switch'
.PHONY: switch

clean:
	@echo "Removing Home Manager configuration..."
	$(require_dotfiles_dir)
	@zsh .bin/unset_mac.sh
.PHONY: clean

nix-uninstall:
	$(require_dotfiles_dir)
	@zsh -c '. .bin/scripts/nix.sh && uninstall_nix'
.PHONY: nix-uninstall
