# ZSH
# Refers to the number of commands that are stored in the zsh history file
SAVEHIST=999999
# Refers to the number of commands that are loaded into memory from the history
HISTSIZE=999999
# Refers to the path/location of the history file
#HISTFILE=~/.zsh_history # default

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

# User configuration
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
export LC_ALL=en_US.UTF-8

# list of plugins (all can be found in ~/.oh-my-zsh/plugins/*)
plugins=()

if [[ "$OSTYPE" == darwin* ]]; then
  # Homebrew
  # TODO: find a better way for checking if brew is installed
  if (type /opt/homebrew/bin/brew &> /dev/null); then
    plugins+=(brew)
    # NOTE: Why -z $VAR and not -z ${VAR+x}: https://stackoverflow.com/a/13864829
    if [[ -z "$HOMEBREW_GITHUB_API_TOKEN" ]]; then
      # Github API Token for Homebrew
      echo "WARNING: Please consider setting \$HOMEBREW_GITHUB_API_TOKEN variable"
      echo "-----"
    fi
  else
    echo "WARNING: Please consider installing Homebrew: https://brew.sh/"
    echo "-----"
  fi
  # iTerm2 tmux integration for zsh
  if test -e "${HOME}/.iterm2_shell_integration.zsh"; then
    source "${HOME}/.iterm2_shell_integration.zsh"
  fi
fi

# tmux plugin configuration
if [[ ! -f "$HOME/.zsh_tmux_autostart_off" ]]; then
  ZSH_TMUX_AUTOSTART="true"
  ZSH_TMUX_AUTOSTART_ONCE="false"
  ZSH_TMUX_AUTOCONNECT="false"
  ZSH_TMUX_AUTOQUIT="true"
  ZSH_TMUX_UNICODE="true"
else
  echo "WARNING: Tmux session will not automagically start"
  echo "WARNING: Please remove $HOME/.zsh_tmux_autostart_off"
  echo "-----"
fi

# list of plugins (all can be found in ~/.oh-my-zsh/plugins/*)
plugins+=(dirrc git helm tmux)
# remind about OMZ updates
zstyle ':omz:update' mode reminder

# load zsh configuration specific for given machine
if test -e "${HOME}/.zshrc.local"; then
  source "${HOME}/.zshrc.local"
fi

if (type vim &> /dev/null); then
  export EDITOR="vim"
else
  echo "WARNING: Please install Vim editor"
  echo "-----"
fi

echo $plugins

# load oh-my-zsh as the last step
source "$ZSH/oh-my-zsh.sh"
