# ---------------------------------- #
# My Configurations
# ---------------------------------- #
source $HOME/.config/zsh/_launch

# ---------------------------------- #
# NVM Configuration (version v0.40.3)
# ---------------------------------- #
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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
