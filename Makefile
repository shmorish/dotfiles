all: brew zsh

zsh:
	@bash install_zsh.sh

brew:
	@bash install_homebrew.sh

check_theme:
	@echo "Checking theme..."
	@echo "Theme: $(ZSH_THEME)"

.PHONY: all brew zsh