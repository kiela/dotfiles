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
		echo "$(tput bold)$(tput setaf 4)MESSAGE:$(tput sgr0)"
		echo -n "$(tput setaf 4)"
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
  local file=$1/${2:-".aliases"}

  if [[ -d $file ]]; then
    __load_dir_aliases $file "_load"
  elif [[ -f $file && -s $file ]]; then
    source $file
    echo "$(tput setaf 2)Directory aliases loaded$(tput sgr0)"
  fi;
}

__load_dir_envs() {
  local file=$1/.env

  if [[ -f $file && -s $file ]]; then
    while read i
    do
      if [[ ($i[1] != '#') && (-n $i[1]) ]]; then
        export ${i//[\'\"\`]}
      fi;
    done < $file
    echo "$(tput setaf 2)Directory ENVs loaded$(tput sgr0)"
  fi;
}

__load_dir_rc() {
  local file=$1/.dirrc

  if [[ -f $file && -s $file ]]; then
    source $file
    echo "$(tput setaf 2)Directory configuration loaded$(tput sgr0)"
  fi;
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
