ZSH=$HOME/.oh-my-zsh
ZSH_THEME="rico"

DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git ruby rails)

export PATH=$PATH:$HOME/.rvm/bin
export EDITOR=vim

source $ZSH/oh-my-zsh.sh

