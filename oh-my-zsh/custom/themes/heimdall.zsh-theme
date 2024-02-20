# Use extended color palette if available
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
	local turquoise="%F{81}"
	local orange="%F{166}"
	local purple="%F{135}"
	local hotpink="%F{161}"
	local limegreen="%F{118}"
	local green="%F{2}"
	local blue="%F{21}"
	local default_color="%f"
else
	local turquoise="$fg[cyan]"
	local orange="$fg[yellow]"
	local purple="$fg[magenta]"
	local hotpink="$fg[red]"
	local limegreen="$fg[green]"
	local green="$fg[green]"
	local blue="$fg[blue]"
	local default_color=$reset_color
fi

time_prompt() {
	echo "%(?.%{$limegreen%}.%{$hotpink%})%D{%H:%M:%S}%{$default_color%}"
}

user_prompt() {
	echo "%{$purple%}%n@%m%{$default_color%}"
}

git_prompt() {
	if { type git &> /dev/null && git rev-parse --is-inside-work-tree &> /dev/null }; then
		echo "$(git_prompt_status) $(git_prompt_info)"
	else
		echo ""
	fi
}

pwd_prompt() {
	echo "%{$blue%}%~%{$default_color%}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$default_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✹"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✹"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[yellow]%}✹"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✹"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}✹"

PROMPT='$(time_prompt) $(user_prompt) $ '
RPROMPT='$(git_prompt) in $(pwd_prompt)'
