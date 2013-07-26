ZSH=$HOME/.oh-my-zsh
ZSH_THEME="rico"

DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git ruby rails)

export PATH="$PATH:$HOME/bin:/usr/local/heroku/bin"
export EDITOR=vim

source $HOME/.rvm/scripts/rvm
source $ZSH/oh-my-zsh.sh

