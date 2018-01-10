# ZSH
HISTSIZE=999999
SAVEHIST=999999

# path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
# set theme
ZSH_THEME="heimdall"
# disable bi-weekly auto-updates checks
DISABLE_AUTO_UPDATE="true"
# disable auto-setting terminal title
DISABLE_AUTO_TITLE="true"
# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
# list of plugins (all can be found in ~/.oh-my-zsh/plugins/*)
plugins=(bundler brew brew-cask git zsh_reload)
# laod oh-my-zsh
source "$ZSH/oh-my-zsh.sh"

# User configuration
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:/usr/local/sbin"
export EDITOR="vim"

# User defined aliases
ALIASES=$HOME/.aliases
if [[ -f $ALIASES && -s $ALIASES ]]; then
	source $ALIASES
	echo "$(tput setaf 2)Aliases loaded$(tput sgr0)"
fi

# Homebrew
if type brew &> /dev/null; then
  # Github API Token for Homebrew
  export HOMEBREW_GITHUB_API_TOKEN="xxx"
fi

# RVM
rvmsudo_secure_path=1
export PATH="$PATH:$HOME/.rvm/bin"
source "$HOME/.rvm/scripts/rvm"
