all: brew zsh

THEME = $(shell grep ZSH_THEME ~/.zshrc | cut -d'"' -f2 | cut -f1 -d " ")

brew:
	@bash install_homebrew.sh

zsh:
	@bash install_zsh.sh

check_theme:
	@echo "Checking theme..."
	@echo "Theme: $(THEME)"

.PHONY: all brew zsh check_theme
