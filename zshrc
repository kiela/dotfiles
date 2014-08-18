# rvm
source $HOME/.rvm/scripts/rvm
export rvmsudo_secure_path=1
export PATH="$HOME/.rvm/bin:$PATH"
export PATH="$HOME/workspace/elixir/elixir/bin:$PATH"

# zsh
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="rico"

DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git rails)

export PATH="$HOME/bin:$PATH"
export EDITOR=vim

source $ZSH/oh-my-zsh.sh
