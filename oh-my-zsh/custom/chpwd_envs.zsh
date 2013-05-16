function chpwd_envs()
{
  if [[ -f ./.env ]]; then
    while read i
    do
      if [ $i[1] != '#' ]; then
        export $i
      fi;
    done < ./.env
    echo "$(tput setaf 2)Envs from current dir was loaded successfully$(tput sgr0)"
  fi;
}

add-zsh-hook chpwd chpwd_envs
