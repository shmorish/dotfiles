all: help
.PHONY: all

help:
	@echo "Available targets:"
	@echo "  all      - Build all targets (default)"
	@echo "  setup    - Setup the environment"
	@echo "  help     - Show this help message"
	@echo "  clean    - Remove all build artifacts"
.PHONY: help

setup:
	@echo "Setting up the environment..."
	@if [ "$$(pwd)" != "${HOME}/dotfiles" ]; then \
		echo "Error: Please run 'make setup' from ${HOME}/dotfiles"; \
		exit 1; \
	fi
	@bash .bin/setup_mac.sh
.PHONY: setup

clean:
	@echo "Cleaning up build artifacts..."
	@if [ "$$(pwd)" != "${HOME}/dotfiles" ]; then \
		echo "Error: Please run 'make clean' from ${HOME}/dotfiles"; \
		exit 1; \
	fi
	@bash .bin/unset_mac.sh
.PHONY: clean
