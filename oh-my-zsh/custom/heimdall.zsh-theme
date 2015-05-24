# Use extended color palette if available
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
    turquoise="%F{81}"
    orange="%F{166}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
	blue="%F{21}"
else
    turquoise="$fg[cyan]"
    orange="$fg[yellow]"
    purple="$fg[magenta]"
    hotpink="$fg[red]"
    limegreen="$fg[green]"
	blue="$fg[blue"]
fi

local time="%(?.%{$limegreen%}.%{$hotpink%})%*%{$reset_color%}"
local user='%{$purple%}%n@%{$purple%}%m%{$reset_color%}'
local pwd='%{$blue%}%~%{$reset_color%}'
local rvm='%{$limegreen%}$(rvm-prompt v p g)%{$reset_color%}'
local git='$(git_prompt_status) $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$limegreen%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED="%{$limegreen%}✹"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$orange%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$hotpink%}✹"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$orange%}✹"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$purple%}✹"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$turquoise%}✹"

PROMPT="${time} ${user} $ "
RPROMPT="${git} ${rvm} in ${pwd}"
