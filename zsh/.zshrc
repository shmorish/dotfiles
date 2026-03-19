# ---------------------------------- #
# My Configurations
# ---------------------------------- #
source $HOME/.config/zsh/init.zsh

# NVM PATH
export NVM_DIR="/opt/homebrew/opt/nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# PATH for llvm, binutils
export PATH=/opt/homebrew/opt/llvm/bin:$PATH
export PATH=/opt/homebrew/sbin:/opt/homebrew/opt/binutils/bin:$PATH

# bun completions
[ -s "/Users/sh-morishita/.bun/_bun" ] && source "/Users/sh-morishita/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# starship
eval "$(starship init zsh)"
