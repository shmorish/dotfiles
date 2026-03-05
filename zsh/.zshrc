# ---------------------------------- #
# My Configurations
# ---------------------------------- #
source $HOME/.config/zsh/_launch

# NVM PATH
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# WezTerm PATH
export WEZTERM_CONFIG_FILE="$HOME/.config/wezterm/wezterm.lua"

# PATH for llvm, binutils
export PATH=/opt/homebrew/opt/llvm/bin:$PATH
export PATH=/opt/homebrew/sbin:/opt/homebrew/opt/binutils/bin:$PATH

# bun completions
[ -s "/Users/sh-morishita/.bun/_bun" ] && source "/Users/sh-morishita/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# starship
eval "$(starship init zsh)"
