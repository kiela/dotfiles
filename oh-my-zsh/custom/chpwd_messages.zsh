function chpwd_messages()
{
  if [[ -f .msg && -s .msg ]]; then
    echo "$(tput bold)$(tput setaf 4)NOTICE:$(tput sgr0)"
    echo -n "$(tput setaf 4)"
    cat .msg
    echo -n "$(tput sgr0)"
  fi;

  if [[ -f .todo && -s .todo ]]; then
    echo "$(tput bold)$(tput setaf 3)TODO:$(tput sgr0)"
    echo -n "$(tput setaf 3)"
    cat .todo
    echo -n "$(tput sgr0)"
  fi;

  if [[ -f .links && -s .links ]]; then
    echo "$(tput bold)$(tput setaf 6)LINKS:$(tput sgr0)"
    echo "$(tput setaf 6)Check out links stored in .links file!$(tput sgr0)"
  fi;
}

add-zsh-hook chpwd chpwd_messages

