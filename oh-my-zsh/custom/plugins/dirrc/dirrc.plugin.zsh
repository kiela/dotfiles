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
  # Resolve symlinks so the comparison matches what dirrc-trust stores.
  # Without this, entering a dir through a symlink (e.g. macOS /tmp -> /private/tmp,
  # or a symlinked checkout) compares the unresolved path against the stored
  # resolved path, so trust never takes effect.
  local __dir="${1:A}"

  # A path containing a newline would occupy several lines in the trust file
  # and grep -Fx would match each independently, so never treat one as trusted.
  [[ "$__dir" == *$'\n'* ]] && return 1

  # the home directory and the dotfiles-managed aliases are always trusted
  if [[ "$__dir" == "${HOME:A}" || "$__dir" == "${HOME:A}/.aliases" ]]; then
    return 0
  fi

  [[ -f "$DIRRC_TRUST_FILE" ]] || return 1
  grep -Fxq "$__dir" "$DIRRC_TRUST_FILE" 2> /dev/null
}

__dirrc_check_trust() {
  local __filepath="$1"
  local __dir="${__filepath:h}"

  if __dirrc_trusted "$__dir"; then
    return 0
  fi

  echo "$(tput setaf 1)Skipping untrusted $__filepath (run 'dirrc-trust $__dir' to allow)$(tput sgr0)"
  return 1
}

dirrc-trust() {
  local __dir="${1:-$PWD}"
  __dir="${__dir:A}"

  if [[ ! -d "$__dir" ]]; then
    echo "dirrc-trust: $__dir: not a directory" >&2
    return 1
  fi

  if [[ "$__dir" == *$'\n'* ]]; then
    echo "dirrc-trust: refusing to trust a path containing a newline" >&2
    return 1
  fi

  if __dirrc_trusted "$__dir"; then
    echo "dirrc: $__dir is already trusted"
  else
    echo "$__dir" >> "$DIRRC_TRUST_FILE"
    echo "dirrc: trusted $__dir"
    dirrc
  fi
}

dirrc-untrust() {
  local __dir="${1:-$PWD}"
  __dir="${__dir:A}"

  if [[ -f "$DIRRC_TRUST_FILE" ]] && grep -Fxq "$__dir" "$DIRRC_TRUST_FILE" 2> /dev/null; then
    grep -Fxv "$__dir" "$DIRRC_TRUST_FILE" > "$DIRRC_TRUST_FILE.tmp"
    mv "$DIRRC_TRUST_FILE.tmp" "$DIRRC_TRUST_FILE"
    echo "dirrc: untrusted $__dir"
  else
    echo "dirrc: $__dir is not trusted"
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

  if [[ -f $__file && -s $__file ]] && __dirrc_check_trust "$__file"; then
    echo "$(tput bold)$(tput setaf 32)MESSAGE:$(tput sgr0)"
    echo -n "$(tput setaf 32)"
    cat $__file
    echo -n "$(tput sgr0)"
  fi;
}

__load_dir_todos() {
  local __file="$1/.todo"

  __debug "__load_dir_todos::\$__file: $__file"

  if [[ -f $__file && -s $__file ]] && __dirrc_check_trust "$__file"; then
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
  local __found=$?
  __debug "__load_dir_envs::\$__filepath: $__filepath"

  if [[ $__found -eq 0 ]]; then
    if [[ -f $__filepath && -s $__filepath ]] && __dirrc_check_trust "$__filepath"; then
      # read -r keeps backslashes intact; the `|| [[ -n "$i" ]]` guard runs
      # the body for a final line that has no trailing newline.
      while read -r i || [[ -n "$i" ]]
      do
        if [[ ($i[1] != '#') && (-n $i[1]) ]]; then
          typeset -x ${i//[\'\"\`]}
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
  local __found=$?
  __debug "__load_dir_rc::\$__filepath: $__filepath"

  if [[ $__found -eq 0 ]]; then
    if [[ -f $__filepath && -s $__filepath ]] && __dirrc_check_trust "$__filepath"; then
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
  __load_dir_aliases $__dir
  __load_dir_envs $__dir
  __load_dir_rc $__dir
}

autoload -U add-zsh-hook
add-zsh-hook chpwd dirrc

dirrc $HOME