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
# tmux plugin configuration
ZSH_TMUX_AUTOSTART="true"
ZSH_TMUX_AUTOSTART_ONCE="false"
ZSH_TMUX_AUTOCONNECT="false"
ZSH_TMUX_AUTOQUIT="true"
ZSH_TMUX_UNICODE="true"
# list of plugins (all can be found in ~/.oh-my-zsh/plugins/*)
plugins=(dirrc docker docker-compose docker-machine git tmux)
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

if [[ "$OSTYPE" == darwin* ]]; then
  # Homebrew
  if type brew &> /dev/null; then
    # Github API Token for Homebrew
    export HOMEBREW_GITHUB_API_TOKEN="xxx"
  fi

  # iTerm2 tmux integration for zsh
  if test -e "${HOME}/.iterm2_shell_integration.zsh"; then
    source "${HOME}/.iterm2_shell_integration.zsh"
  fi
fi

if type kubectl &> /dev/null; then
  source <(kubectl completion zsh)
fi

if type gcloud &> /dev/null; then
  source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi
