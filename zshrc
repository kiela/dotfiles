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
if [[ ! -f "$HOME/.zsh_tmux_autostart_off" ]]; then
  ZSH_TMUX_AUTOSTART="true"
  ZSH_TMUX_AUTOSTART_ONCE="false"
  ZSH_TMUX_AUTOCONNECT="false"
  ZSH_TMUX_AUTOQUIT="true"
  ZSH_TMUX_UNICODE="true"
else
  echo "Tmux session will not automagically start"
  echo "Please remove $HOME/.zsh_tmux_autostart_off"
  echo "-----"
fi
# list of plugins (all can be found in ~/.oh-my-zsh/plugins/*)
plugins=(dirrc docker docker-compose docker-machine git tmux)
# remind about OMZ updates
zstyle ':omz:update' mode reminder

# User configuration
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
export EDITOR="vim"
export LC_ALL=en_US.UTF-8

if test -e "${HOME}/.zshrc.local"; then
  source "${HOME}/.zshrc.local"
fi

if [[ "$OSTYPE" == darwin* ]]; then
  # Homebrew
  # NOTE: Why -z $VAR and not -z ${VAR+x}: https://stackoverflow.com/a/13864829
  if type brew &> /dev/null && [[ -z "$HOMEBREW_GITHUB_API_TOKEN" ]]; then
    # Github API Token for Homebrew
    echo "Please consider setting \$HOMEBREW_GITHUB_API_TOKEN variable"
    echo "-----"
  fi

  # iTerm2 tmux integration for zsh
  if test -e "${HOME}/.iterm2_shell_integration.zsh"; then
    source "${HOME}/.iterm2_shell_integration.zsh"
  fi
fi

if type gcloud &> /dev/null; then
  source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi
# load oh-my-zsh as the last step
source "$ZSH/oh-my-zsh.sh"
