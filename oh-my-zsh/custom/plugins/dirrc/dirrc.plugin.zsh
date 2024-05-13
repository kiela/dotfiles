V=${V:-false}
#V=true

__debug() {
  if $V; then
    echo "DEBUG: $1"
  fi
}

__load_dir_links() {
#  local __filepth=$1/.links
  local __file="$1/.links"

  if [[ -f $__file && -s $__file ]]; then
    echo "$(tput bold)$(tput setaf 6)LINKS:$(tput sgr0)"
    echo "$(tput setaf 6)Check out links stored in .links file!$(tput sgr0)"
  fi;
}

__load_dir_messages() {
#  local __filepth=$1/.msg
  local __file="$1/.msg"

  if [[ -f $__file && -s $__file ]]; then
    echo "$(tput bold)$(tput setaf 32)MESSAGE:$(tput sgr0)"
    echo -n "$(tput setaf 32)"
    cat $__file
    echo -n "$(tput sgr0)"
  fi;
}

__load_dir_todos() {
#  local __filepth=$1/.todo
  local __file="$1/.todo"

  if [[ -f $__file && -s $__file ]]; then
    echo "$(tput bold)$(tput setaf 3)TODO:$(tput sgr0)"
    echo -n "$(tput setaf 3)"
    cat $__file
    echo -n "$(tput sgr0)"
  fi;
}

__load_dir_aliases() {
  local __dir=${1:-$PWD}
  local __filename=${2:-".aliases"}
  local __filepath

  __debug "__load_dir_aliases::\$__dir: $__dir"
  __debug "__load_dir_aliases::\$__filename: $__filename"

  if [[ -d $__dir/$__filename ]]; then
    __load_dir_aliases "$__dir/$__filename" "_load"
  else
    __filepath=$(__find_dir_file $__dir $__filename)
    __debug "__load_dir_aliases::\$__filepath: $__filepath"

    if [[ $? -eq 0 ]]; then
      if [[ -f $__filepath && -s $__filepath ]]; then
        source $__filepath
        echo "$(tput setaf 2)Directory aliases loaded$(tput sgr0)"
      fi
    else
      echo "$(tput setaf 2)Directory aliases not loaded$(tput sgr0)"
    fi
  fi;
}

__load_dir_envs() {
  local __dir=${1:-$PWD}
  local __filename=".env"
  local __filepath

  __debug "__load_dir_envs::\$__dir: $__dir"
  __debug "__load_dir_envs::\$__filename: $__filename"

  __filepath=$(__find_dir_file $__dir $__filename)
  __debug "__load_dir_envs::\$__filepath: $__filepath"

  if [[ $? -eq 0 ]]; then
    if [[ -f $__filepath && -s $__filepath ]]; then
      while read i
      do
        if [[ ($i[1] != '#') && (-n $i[1]) ]]; then
          export ${i//[\'\"\`]}
        fi;
      done < $__filepath
      echo "$(tput setaf 2)Directory ENVs loaded$(tput sgr0)"
    fi
  else
    echo "$(tput setaf 1)Directory ENVs not loaded$(tput sgr0)"
  fi
}

__load_dir_rc() {
  local __dir=${1:-$PWD}
  local __filename=".dirrc"
  local __filepath

  __debug "__load_dir_rc::\$__dir: $__dir"
  __debug "__load_dir_rc::\$__filename: $__filename"

  __filepath=$(__find_dir_file $__dir $__filename)
  __debug "__load_dir_rc::\$__filepath: $__filepath"

  if [[ $? -eq 0 ]]; then
    if [[ -f $__filepath && -s $__filepath ]]; then
      source $__filepath
      echo "$(tput setaf 2)Directory configuration loaded$(tput sgr0)"
    fi
  else
    echo "$(tput setaf 1)WARNING: Directory configuration not loaded$(tput sgr0)"
  fi;
}

__find_dir_file() {
  local __start_dir=$1
  local __filename=$2
  local __previous_dir=""

  if [[ -z "$__start_dir" || -z "$__filename" ]]; then
    echo "$(tput setaf 1)WARNING: __find_dir_file(): Required arguments are missing$(tput sgr0)"
    return 1
  fi

  while [[ "$__start_dir" != "$__previous_dir" ]]; do
    local __filepath="$__start_dir/$__filename"

    if [[ -f "$__filepath" ]]; then
      echo "$__filepath"
      return 0
    else
      __previous_dir=$__start_dir
      __start_dir=$(dirname "$__start_dir")
    fi
  done
}

dirrc() {
  local __dir=${1:-$PWD}

  # Directory information
  __load_dir_links $__dir
  __load_dir_messages $__dir
  __load_dir_todos $__dir

  # Directory runtime configuration
  # load global aliases and directory aliases as well
  #__load_dir_aliases $HOME
  #__load_dir_aliases $PWD
  __load_dir_aliases $__dir
  __load_dir_envs $__dir
  __load_dir_rc $__dir
}

autoload -U add-zsh-hook
add-zsh-hook chpwd dirrc

dirrc $HOME
