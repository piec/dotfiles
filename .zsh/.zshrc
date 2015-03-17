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

if [[ "$OSTYPE" = darwin* ]]; then
    (( $+commands[gls] )) && alias ls="gls --color=auto"
    (( $+commands[gdircolors] )) && eval $(gdircolors)
fi

alias ls="LC_COLLATE=C ${aliases[ls]}"
alias l="ls -la"

setopt LIST_PACKED
unsetopt SHARE_HISTORY
setopt HUP
setopt CHECK_JOBS

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
    find "${2-.}" -type d -name .git -prune -o -type d -name .hg -prune -o -type d -name .svn -prune -o -iname "*$1*" -print | grep -i "$1"
}

function g {
    local pattern="$1"; shift
    [ "$pattern" = "" ] && return 1

    local dir='.'
    if [ "$1" != "" ]; then
        dir="$1"; shift
    fi

    if ! [ -d "$dir" ]; then
        echo "not a directory '$dir'"
        return 1
    fi
    echo grep -i "$pattern" -R "$dir" "$@"
    grep -i "$pattern" -R "$dir" "$@"
}

function gw {
    local word="$1"; shift
    g "\<${word}\>" . "$@"
}

# ---

[ -e ~/.zshrc ] && . ~/.zshrc
