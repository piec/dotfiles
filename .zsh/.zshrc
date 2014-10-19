#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

[[ "$OSTYPE" = darwin* ]] && (( $+commands[gls] )) && alias ls="gls --color=auto"
alias l="ls -la"
setopt LIST_PACKED
unsetopt SHARE_HISTORY

export EDITOR=vim
export VISUAL=vim

path+=(~/bin)

alias -g L="| less"
alias -s txt=vim

bindkey -M isearch "\e[A" history-beginning-search-backward
bindkey -M isearch "\e[B" history-beginning-search-forward
bindkey "\ep" history-beginning-search-backward
bindkey "\en" history-beginning-search-forward

bindkey '\ee' edit-command-line
bindkey "^U" backward-kill-line

# ---

bindkey "\e[21~" run-mc
zle -N run-mc
function run-mc {
    source /usr/lib/mc/mc-wrapper.sh
    zle clear-screen
    zle redisplay
}

function f {
    find ${2-.} -type d -name .git -prune -o -type d -name .hg -prune -o -type d -name .svn -prune -o -iname "*$1*" -print | grep -i "$1"
}

function g {
    [ x$1 != x ] || return 1
    local dir=${2-.}
    [ -d $dir ] || return 1
    grep -i "$1" -R $dir
}

function gw {
    g "\<$1\>"
}

# ---

[ -e ~/.zshrc ] && . ~/.zshrc
