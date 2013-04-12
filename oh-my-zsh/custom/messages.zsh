function chpwd()
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
}
