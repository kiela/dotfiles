local user='%{$fg[magenta]%}%n@%{$fg[magenta]%}%m%{$reset_color%}'
local pwd='%{$fg[blue]%}%~%{$reset_color%}'

local erlang='%{$fg[green]%}‹$(erl -eval "erlang:display(erlang:system_info(otp_release)), halt()."  -noshell  | sed -n "/R[0-9][0-9][A|B][0-9][0-9]/ s/.*\(R[0-9][0-9][A|B][0-9][0-9]\).*/\1/p")›%{$reset_color%}'

local rvm=''
if which rvm-prompt &> /dev/null; then
  rvm='%{$fg[green]%}‹$(rvm-prompt v p g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm='%{$fg[green]%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi
local git_branch=' $(git_prompt_status)%{$reset_color%}$(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}✭"

PROMPT="${user} ${pwd}$ "
RPROMPT="${git_branch} ${erlang} ${rvm}"
