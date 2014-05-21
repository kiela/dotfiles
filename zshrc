ZSH=$HOME/.oh-my-zsh
ZSH_THEME="rico"

DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git ruby rails)

export PATH="$PATH:$HOME/bin:/usr/local/heroku/bin"
export EDITOR=vim

source $ZSH/oh-my-zsh.sh

# RVM
export rvmsudo_secure_path=1
PATH=$PATH:$HOME/.rvm/bin
