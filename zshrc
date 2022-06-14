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
plugins=(dirrc docker docker-compose docker-machine git)
# remind about OMZ updates
zstyle ':omz:update' mode reminder
# laod oh-my-zsh
source "$ZSH/oh-my-zsh.sh"

# User configuration
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
export EDITOR="vim"
export LC_ALL=en_US.UTF-8

# Homebrew
if type brew &> /dev/null; then
  # Github API Token for Homebrew
  export HOMEBREW_GITHUB_API_TOKEN="xxx"
fi

