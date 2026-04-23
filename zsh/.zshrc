# ---------------------------------- #
# My Configurations
# ---------------------------------- #

# PATH for llvm, binutils
export PATH=/opt/homebrew/opt/llvm/bin:$PATH
export PATH=/opt/homebrew/sbin:/opt/homebrew/opt/binutils/bin:$PATH

# bun completions
[ -s "/Users/sh-morishita/.bun/_bun" ] && source "/Users/sh-morishita/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# sheldon
eval "$(sheldon source)"

source $HOME/.config/zsh/init.zsh

# mise
eval "$(mise activate zsh)"

# starship
eval "$(starship init zsh)"
