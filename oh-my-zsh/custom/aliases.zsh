ALIASES=$HOME/.aliases
if [[ -f $ALIASES && -s $ALIASES ]]; then
	source $ALIASES
	echo "$(tput setaf 2)Aliases loaded$(tput sgr0)"
fi;
