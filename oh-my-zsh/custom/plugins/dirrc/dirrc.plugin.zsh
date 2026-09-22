V=${V:-false}

__debug() {
  if $V; then
    echo "DEBUG: $1"
  fi
}

# Sourcing .aliases/.env/.dirrc from any directory entered with cd means
# arbitrary code execution when entering an untrusted checkout. Like
# direnv, require directories to be trusted first (one absolute path per
# line in $DIRRC_TRUST_FILE, managed with dirrc-trust / dirrc-untrust).
DIRRC_TRUST_FILE="${DIRRC_TRUST_FILE:-$HOME/.dirrc_trusted}"

__dirrc_trusted() {
  local __dir="$1"

  # the home directory and the dotfiles-managed aliases are always trusted
  if [[ "$__dir" == "$HOME" || "$__dir" == "$HOME/.aliases" ]]; then
    return 0
  fi

  [[ -f "$DIRRC_TRUST_FILE" ]] || return 1
  grep -Fxq "$__dir" "$DIRRC_TRUST_FILE" 2> /dev/null
}

# Every status line goes through here so they share one shape:
# "dirrc: <text>", coloured by kind, errors on stderr.
__dirrc_msg() {
  local __kind="$1"
  shift
  local __colour=""

  case "$__kind" in
    ok) __colour="$(tput setaf 2)" ;;
    warn) __colour="$(tput setaf 3)" ;;
    err) __colour="$(tput setaf 1)" ;;
  esac

  if [[ "$__kind" == "err" ]]; then
    echo "${__colour}dirrc: $*$(tput sgr0)" >&2
  else
    echo "${__colour}dirrc: $*$(tput sgr0)"
  fi
}

# Abbreviate a path for messages ($HOME becomes ~). __dirrc_arg gives the
# matching command suffix, kept empty for the current directory since the
# commands already default to $PWD.
__dirrc_display() {
  print -rD -- "$1"
}

__dirrc_arg() {
  if [[ "$1" == "$PWD" ]]; then
    print -r -- ""
  else
    print -r -- " $(print -rD -- "$1")"
  fi
}

__dirrc_check_trust() {
  local __filepath="$1"
  local __dir="${__filepath:h}"

  if __dirrc_trusted "$__dir"; then
    return 0
  fi

  local __shown __arg
  local __red="$(tput setaf 1)" __bold="$(tput bold)" __reset="$(tput sgr0)"

  # A config file can come from an ancestor directory, where the bare
  # commands - which default to $PWD - would act on the wrong directory.
  if [[ "$__dir" == "$PWD" ]]; then
    __shown="./${__filepath:t}"
  else
    __shown="$(__dirrc_display "$__filepath")"
  fi
  __arg="$(__dirrc_arg "$__dir")"

  echo "${__red}dirrc: skipping untrusted ${__bold}${__shown}${__reset}${__red}. Inspect it with ${__bold}'dirrc-show${__arg}'${__reset}${__red}, then allow with ${__bold}'dirrc-trust${__arg}'${__reset}${__red}.${__reset}"
  return 1
}

dirrc-trust() {
  local __dir="${1:-$PWD}"
  __dir="${__dir:A}"

  if [[ ! -d "$__dir" ]]; then
    __dirrc_msg err "$(__dirrc_display "$__dir") is not a directory"
    return 1
  fi

  if __dirrc_trusted "$__dir"; then
    __dirrc_msg plain "$(tput bold)$(__dirrc_display "$__dir")$(tput sgr0) is already trusted"
  else
    echo "$__dir" >> "$DIRRC_TRUST_FILE"
    __dirrc_msg ok "trusted $(tput bold)$(__dirrc_display "$__dir")$(tput sgr0)$(tput setaf 2)"
    dirrc
  fi
}

dirrc-untrust() {
  local __dir="${1:-$PWD}"
  __dir="${__dir:A}"

  if [[ -f "$DIRRC_TRUST_FILE" ]] && grep -Fxq "$__dir" "$DIRRC_TRUST_FILE" 2> /dev/null; then
    grep -Fxv "$__dir" "$DIRRC_TRUST_FILE" > "$DIRRC_TRUST_FILE.tmp"
    mv "$DIRRC_TRUST_FILE.tmp" "$DIRRC_TRUST_FILE"
    __dirrc_msg ok "untrusted $(tput bold)$(__dirrc_display "$__dir")$(tput sgr0)$(tput setaf 2)"
  else
    __dirrc_msg plain "$(tput bold)$(__dirrc_display "$__dir")$(tput sgr0) is not trusted"
  fi
}

# Print the files dirrc would execute in a directory, so an untrusted one
# can be read before deciding whether to trust it. Only the executable
# files are shown - .links/.msg/.todo are displayed by dirrc anyway.
dirrc-show() {
  local __dir="${1:-$PWD}"
  __dir="${__dir:A}"
  local __file __loadfile __found=1

  if [[ ! -d "$__dir" ]]; then
    __dirrc_msg err "$(__dirrc_display "$__dir") is not a directory"
    return 1
  fi

  for __file in "$__dir/.aliases" "$__dir/.env" "$__dir/.dirrc"; do
    [[ -e "$__file" ]] || continue
    __found=0

    if [[ -d "$__file" ]]; then
      __loadfile="$__file/_load"

      if [[ -f "$__loadfile" ]]; then
        echo "$(tput bold)$(tput setaf 6)----- $(__dirrc_display "$__loadfile") -----$(tput sgr0)"
        cat "$__loadfile"
      else
        echo "$(tput bold)$(tput setaf 6)----- $(__dirrc_display "$__file")/ (no _load file) -----$(tput sgr0)"
      fi
    else
      echo "$(tput bold)$(tput setaf 6)----- $(__dirrc_display "$__file") -----$(tput sgr0)"
      cat "$__file"
    fi
  done

  if [[ $__found -ne 0 ]]; then
    __dirrc_msg plain "nothing to source in $(tput bold)$(__dirrc_display "$__dir")$(tput sgr0)"
    return 1
  fi

  if __dirrc_trusted "$__dir"; then
    __dirrc_msg ok "$(tput bold)$(__dirrc_display "$__dir")$(tput sgr0)$(tput setaf 2) is trusted"
  else
    __dirrc_msg warn "$(tput bold)$(__dirrc_display "$__dir")$(tput sgr0)$(tput setaf 3) is not trusted. Allow it with $(tput bold)'dirrc-trust$(__dirrc_arg "$__dir")'$(tput sgr0)$(tput setaf 3)."
  fi
}

__load_dir_links() {
  local __file="$1/.links"

  __debug "__load_dir_links::\$__file: $__file"

  if [[ -f $__file && -s $__file ]]; then
    echo "$(tput bold)$(tput setaf 6)LINKS:$(tput sgr0)"
    echo "$(tput setaf 6)Check out links stored in .links file!$(tput sgr0)"
  fi;
}

__load_dir_messages() {
  local __file="$1/.msg"

  __debug "__load_dir_messages::\$__file: $__file"

  if [[ -f $__file && -s $__file ]]; then
    echo "$(tput bold)$(tput setaf 32)MESSAGE:$(tput sgr0)"
    echo -n "$(tput setaf 32)"
    cat $__file
    echo -n "$(tput sgr0)"
  fi;
}

__load_dir_todos() {
  local __file="$1/.todo"

  __debug "__load_dir_todos::\$__file: $__file"

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
    local __found=$?
    __debug "__load_dir_aliases::\$__filepath: $__filepath"

    if [[ $__found -eq 0 ]]; then
      if [[ -f $__filepath && -s $__filepath ]] && __dirrc_check_trust "$__filepath"; then
        source $__filepath
        __dirrc_msg ok "directory aliases loaded"
      fi
    else
      __dirrc_msg warn "directory aliases not loaded"
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
  local __found=$?
  __debug "__load_dir_envs::\$__filepath: $__filepath"

  if [[ $__found -eq 0 ]]; then
    if [[ -f $__filepath && -s $__filepath ]] && __dirrc_check_trust "$__filepath"; then
      while read i
      do
        if [[ ($i[1] != '#') && (-n $i[1]) ]]; then
          typeset -x ${i//[\'\"\`]}
        fi;
      done < $__filepath
      __dirrc_msg ok "directory envs loaded"
    fi
  else
    __dirrc_msg warn "directory envs not loaded"
  fi
}

__load_dir_rc() {
  local __dir=${1:-$PWD}
  local __filename=".dirrc"
  local __filepath

  __debug "__load_dir_rc::\$__dir: $__dir"
  __debug "__load_dir_rc::\$__filename: $__filename"

  __filepath=$(__find_dir_file $__dir $__filename)
  local __found=$?
  __debug "__load_dir_rc::\$__filepath: $__filepath"

  if [[ $__found -eq 0 ]]; then
    if [[ -f $__filepath && -s $__filepath ]] && __dirrc_check_trust "$__filepath"; then
      source $__filepath
      __dirrc_msg ok "directory configuration loaded"
    fi
  else
    __dirrc_msg warn "directory configuration not loaded"
  fi;
}

__find_dir_file() {
  local __start_dir=$1
  local __filename=$2
  local __previous_dir=""

  if [[ -z "$__start_dir" || -z "$__filename" ]]; then
    __dirrc_msg err "__find_dir_file() needs a directory and a filename"
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
  __load_dir_aliases $__dir
  __load_dir_envs $__dir
  __load_dir_rc $__dir
}

autoload -U add-zsh-hook
add-zsh-hook chpwd dirrc

dirrc $HOME