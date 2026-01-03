help:
	@echo "Available targets:"
	@echo "  setup    - Setup the environment"
	@echo "  help     - Show this help message"
	@echo "  clean    - Remove all build artifacts"
.PHONY: help

install_submodules:
	@git submodule update --init --recursive
.PHONY: install_submodules

setup: install_submodules
	@echo "Setting up the environment..."
	@if [ "$$(pwd)" != "${HOME}/dotfiles" ]; then \
		echo "Error: Please run 'make setup' from ${HOME}/dotfiles"; \
		exit 1; \
	fi
	@zsh .bin/setup_mac.sh
.PHONY: setup

clean:
	@echo "Cleaning up build artifacts..."
	@if [ "$$(pwd)" != "${HOME}/dotfiles" ]; then \
		echo "Error: Please run 'make clean' from ${HOME}/dotfiles"; \
		exit 1; \
	fi
	@zsh .bin/unset_mac.sh
.PHONY: clean
