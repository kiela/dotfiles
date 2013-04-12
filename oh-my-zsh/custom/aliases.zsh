#!/usr/bin/env bash

alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

alias c=clear
alias cc=clear
alias la='ls -a'
alias lf='ls -Fa'
alias ll='ls -alF'
alias sl=ls
alias sls=ls
alias lh='ls -lh'
alias l='ls -CF'
alias ..='cd ..'
alias cd..='cd ..'
alias .='cd ~'
alias h='history 25'
alias j='jobs -l'
alias x=exit

alias df='df -h'
alias du='du -h'
alias duh='du -H'
alias r='source ~/.zshrc'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias rgrep='clear && grep --exclude-dir=log --exclude-dir=tmp'
