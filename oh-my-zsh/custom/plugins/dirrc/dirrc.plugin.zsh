__load_dir_links() {
  local file=$1/.links

  if [[ -f $file && -s $file ]]; then
    echo "$(tput bold)$(tput setaf 6)LINKS:$(tput sgr0)"
    echo "$(tput setaf 6)Check out links stored in .links file!$(tput sgr0)"
  fi;
}

__load_dir_messages() {
  local file=$1/.msg

  if [[ -f $file && -s $file ]]; then
    echo "$(tput bold)$(tput setaf 32)MESSAGE:$(tput sgr0)"
    echo -n "$(tput setaf 32)"
    cat $file
    echo -n "$(tput sgr0)"
  fi;
}

__load_dir_todos() {
  local file=$1/.todo

  if [[ -f $file && -s $file ]]; then
    echo "$(tput bold)$(tput setaf 3)TODO:$(tput sgr0)"
    echo -n "$(tput setaf 3)"
    cat $file
    echo -n "$(tput sgr0)"
  fi;
}

__load_dir_aliases() {
  local dir=${1:-$PWD}
  local filename=${2:-".aliases"}
  local filepath

  if [[ -d $dir/$filename ]]; then
    __load_dir_aliases "$dir/$filename" "_load"
  else
    __filepath=$(__find_dir_file $dir $filename)

    if [[ $? -eq 0 ]]; then
      if [[ -f $filepath && -s $filepath ]]; then
        source $filepath
        echo "$(tput setaf 2)Directory aliases loaded$(tput sgr0)"
      fi
    else
      echo "$(tput setaf 2)Directory aliases not loaded$(tput sgr0)"
    fi
  fi;
}

__load_dir_envs() {
  local dir=${1:-$PWD}
  local filename=".env"
  local filepath

  __filepath=$(__find_dir_file $dir $filename)

  if [[ $? -eq 0 ]]; then
    if [[ -f $filepath && -s $filepath ]]; then
      while read i
      do
        if [[ ($i[1] != '#') && (-n $i[1]) ]]; then
          export ${i//[\'\"\`]}
        fi;
      done < $filepath
      echo "$(tput setaf 2)Directory ENVs loaded$(tput sgr0)"
    fi
  else
    echo "$(tput setaf 1)Directory ENVs not loaded$(tput sgr0)"
  fi
}

__load_dir_rc() {
  local dir=${1:-$PWD}
  local filename=".dirrc"
  local filepath


  __filepath=$(__find_dir_file $dir $filename)

  if [[ $? -eq 0 ]]; then
    if [[ -f $filepath && -s $filepath ]]; then
      source $filepath
      echo "$(tput setaf 2)Directory configuration loaded$(tput sgr0)"
    fi
  else
    echo "$(tput setaf 1)WARNING: Directory configuration not loaded$(tput sgr0)"
  fi;
}

__find_dir_file() {
  local start_dir=$1
  local filename=$2
  local previous_dir=""

  if [[ -z "$start_dir" || -z "$filename" ]]; then
    echo "$(tput setaf 1)WARNING: __find_dir_file(): Required arguments are missing$(tput sgr0)"
    return 1
  fi

  while [[ "$start_dir" != "$previous_dir" ]]; do
    local filepath="$start_dir/$filename"

    if [[ -f "$filepath" ]]; then
      echo "$filepath"
      return 0
    else
      __previous_dir=$start_dir
      __start_dir=$(dirname "$start_dir")
    fi
  done
}

dirrc() {
  local dir=${1:-$PWD}

  # Directory information
  __load_dir_links $dir
  __load_dir_messages $dir
  __load_dir_todos $dir

  # Directory runtime configuration
  __load_dir_aliases $dir
  __load_dir_envs $dir
  __load_dir_rc $dir
}

autoload -U add-zsh-hook
add-zsh-hook chpwd dirrc

dirrc $HOME
