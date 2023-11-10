# Global configuration
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
export LC_ALL=en_US.UTF-8

if (type vim &> /dev/null); then
  export EDITOR="vim"
else
  echo "WARNING: Please install Vim editor"
  echo "-----"
fi

# ZSH
# Refers to the number of commands that are stored in the zsh history file
SAVEHIST=999999
# Refers to the number of commands that are loaded into memory from the history
HISTSIZE=999999
# Refers to the path/location of the history file
#HISTFILE=~/.zsh_history # default

# Oh My ZSH
if test -e "${HOME}/.oh-my-zsh.rc"; then
  source "${HOME}/.oh-my-zsh.rc"
fi
