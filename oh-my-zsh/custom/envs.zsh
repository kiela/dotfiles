ENVS=$HOME/.envs
if [[ -f $ENVS && -s $ENVS ]]; then
	source $ENVS
	echo "$(tput setaf 2)Envs loaded$(tput sgr0)"
fi;
