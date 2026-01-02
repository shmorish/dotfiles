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
