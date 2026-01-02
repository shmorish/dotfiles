# ---------------------------------- #
# Oh My Zsh Configuration
# ---------------------------------- #
ZSH_THEME="shmorish"
plugins=(
  alias-finder
  aws
  branch
  brew
  bun
  git
  httpie
  vscode
  z
  zsh-autosuggestions
)
ZSH="$HOME/dotfiles/oh-my-zsh"
source $ZSH/oh-my-zsh.sh

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
