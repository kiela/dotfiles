function chpwd()
{
  if [[ -f .env ]]; then
    source .env
    echo "$(tput setaf 2)Envs from current dir was loaded successfully$(tput sgr0)"
  fi
}
