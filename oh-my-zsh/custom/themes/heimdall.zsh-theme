# Exit when extended color palette is not available
if [[ ! $TERM =~ '256color' ]]; then
    echo "Terminal does not support 256 colors."
    exit 1
fi


export LSCOLORS="gxfxcxdxbxegedabagacad"
#export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;46:su=30:sg=30:tw=30:ow=30"

# NOTE: 
#   %F{code} for foreground colors
#   %K{code} for background colors
local turquoise="%F{81}"
local orange="%F{166}"
local purple="%F{135}"
local hotpink="%F{161}"
local limegreen="%F{118}"
local green="%F{2}"
local reset_color="%f"

time_prompt() {
  echo "%(?.%{$limegreen%}.%{$hotpink%})%D{%H:%M:%S}%{$reset_color%}"
}

user_prompt() {
  echo "%{$purple%}%n@%m%{$reset_color%}"
}

git_prompt() {
  if { type git &> /dev/null && git rev-parse --is-inside-work-tree &> /dev/null }; then
    # NOTE: https://github.com/ohmyzsh/ohmyzsh/issues/12328
    #echo "$(git_prompt_status) $(git_prompt_info)"
    echo "$(_omz_git_prompt_status) $(_omz_git_prompt_info)"
  else
    echo ""
  fi
}

pwd_prompt() {
  echo "%{$fg[cyan]%}%~%{$reset_color%}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
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
