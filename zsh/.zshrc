source ~/dotfiles/znap/zsh-snap/znap.zsh

#region prezto
if [[ "$TERM" == 'dumb' ]]; then
    zstyle ':prezto:*:*' color 'no'
    zstyle ':prezto:module:prompt' theme 'off'
else
    zstyle ':prezto:*:*' color 'yes'
fi

# workaround because znap does not add `functions/` directories to fpath
# when using `znap source ...`
fpath=($HOME/dotfiles/znap/piec/dotfiles/.zsh/.zprezto/modules/prompt/functions $fpath)

zstyle ':prezto:module:editor' key-bindings 'emacs'
zstyle ':prezto:module:editor:info:completing' format '...'

zstyle ':prezto:module:prompt' theme 'fade' 'magenta'
zstyle ':fzf:bindings' history '\er'

function pmodload {
  # echo "nope $0 $*"
}


znap source 'sorin-ionescu/prezto' \
    'modules/helper/init.zsh' \
    \
    'modules/environment/init.zsh' \
    'modules/terminal/init.zsh' \
    'modules/editor/init.zsh' \
    'modules/history/init.zsh' \
    'modules/directory/init.zsh' \
    'modules/spectrum/init.zsh' \
    'modules/completion/init.zsh' \
    'modules/syntax-highlighting/init.zsh' \
    'modules/command-not-found/init.zsh' \
    'modules/autosuggestions/init.zsh' \

#endregion

# -----------------------------------------
#region ??

# utility
autoload -Uz run-help-{ip,openssl,sudo}

# Grep
if is-callable 'dircolors'; then
  eval "$(dircolors --sh $HOME/.dir_colors(N))"
fi

if is-darwin; then
  alias o='open'
else
  alias o='xdg-open'
fi

function mkcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

#endregion

# -----------------------------------------

# znap source 'piec/fzf-prezto' 'init.zsh'

# TODO runcoms?

# prompt
# TODO use znap prompt
fpath=($HOME/dotfiles/zsh/functions/ $fpath)
autoload -Uz promptinit && promptinit
prompt fade2 magenta

# -----------------------------------------

function unset_func {
  (( $+functions[$1] )) && unset -f "$1"
  (( $+aliases[$1] )) && unalias "$1"
}
# -----------------------------------------
#region prefs

alias ls="LC_COLLATE=C ls --color --group-directories-first"
alias l="${aliases[ls]:-ls} -la"
alias tiga="tig --all"
alias svim="sudo -E vim"
# alias grep="${aliases[grep]:-grep} --exclude-dir=\.svn --exclude-dir=\.hg --exclude-dir=\.git"
alias s="sudo -E systemctl"
alias j="sudo -E journalctl"
#alias n="sudo netctl"

alias mc=". /usr/lib/mc/mc-wrapper.sh"
alias vi=vim

alias -g L="|& less"
alias -g H="|& head"
alias -g S="|& sort"
alias -g V="|& vim -"
alias -g X="|& sed -z 's/\n*\$//' | sed 's|^${HOME}|~|g' | xclip -f -selection primary | xclip -selection clipboard"
alias -g G='; ntfy send powa "done $?"'
alias -g N='; notify-send -u critical "done $?"'
alias -s txt=vim

function R {
    realpath "$@" X
}

alias cp="${aliases[cp]:-cp} -i"
alias ln="${aliases[ln]:-ln} -i"
alias mv="${aliases[mv]:-mv} -i"
alias rm="${aliases[rm]:-rm} -i"

path+=~/bin
path+=~/dotfiles/bin

export EDITOR=vim
export VISUAL=vim

[ "$TERM" = xterm ] && export TERM=xterm-256color
[ "$TERM" = screen ] && export TERM=screen-256color

setopt CORRECT
setopt LIST_PACKED
setopt HUP
setopt CHECK_JOBS
setopt PROMPT_SP

unsetopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

HISTFILE=~/.zhistory
HISTSIZE=50000
SAVEHIST=50000

export LESS="-g -i -M -R -S -w -X -z-4"

#endregion

# -----------------------------------------

#region bindkey

bindkey -M isearch "\e[A" history-beginning-search-backward
bindkey -M isearch "\e[B" history-beginning-search-forward
bindkey "\ep" history-beginning-search-backward
bindkey "\en" history-beginning-search-forward

bindkey '\ee' edit-command-line
bindkey "^U" backward-kill-line

bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

bindkey "\e[1;3C" forward-word
bindkey "\e[1;3D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e" backward-delete-word

autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "\em" copy-earlier-word

# ---------------------------

bindkey "\eO5A" cd-up
bindkey "\e[1;5A" cd-up
bindkey "\e[3;5A" cd-up

zle -N cd-up
function cd-up {
    cd ..
    zle -I
}

bindkey "\e[21~" run-mc
zle -N run-mc
function run-mc {
    source /usr/lib/mc/mc-wrapper.sh
    zle clear-screen
    zle redisplay
}

bindkey '^X^X' sudo-command-line
function sudo-command-line {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="svim $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    elif [[ $BUFFER == svim\ * ]]; then
        LBUFFER="${LBUFFER#svim }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
    zle redisplay
}
zle -N sudo-command-line

bindkey 'i' install-package
zle -N install-package
function install-package {
    local word pkgs cursor
    cursor="$CURSOR"
    zle up-line-or-history
    local word="${BUFFER[(w)1]}"
    zle down-line-or-history

    pkgs=(${(f)"$(pkgfile -b -- "$word" 2>/dev/null)"})

    if [ -n "${pkgs[1]}" ]; then
        LBUFFER="sudo pacman -S ${pkgs[1]}"
    else
        CURSOR="$cursor"
    fi
}

# ---------------------------

zstyle ':zle:transpose-words*' word-style shell

autoload -Uz transpose-words-match
zle -N transpose-words-match
bindkey "^[t" transpose-words-match

# ---------------------------

function f {
    find "${2-.}" -type d -name .git -prune -o -type d -name .hg -prune -o -type d -name .svn -prune -o -iname "*$1*" -print
    #| grep -i "$1"
}
alias f='noglob f'

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

function h {
    if [ "$1" != "" ]; then
        fc -li 0 | grep -i "$*"
    else
        fc -li 0
    fi
}
alias h='noglob h'

function db() {
    setopt LOCAL_OPTIONS NULL_GLOB
    if [ "$*" = "" ]; then
        set -- * .*
    fi
    sudo du -x -s -BM "$@"
}

unset_func d
function d() {
    db "$@" | sort -n
}

unset_func p
function p {
    pgrep -iaf "$@"
    #ps auxf | grep "$@"
}

# ---------------------------

function word {
    awk "{print \$${1:-1}}"
}

# ---------------------------

if (( $+commands[pacman] )); then
    function files {
        name="$1"
        if [ $# = 1 ]; then
            pacman -Qlq "$name" | grep -v /$
        else
            shift
            pacman -Qlq "$name" | grep -v /$ | xargs grep --color=auto "$@"
        fi
    }
    #function _files { _pacman; _arguments -s : '*:package:_pacman_completions_installed_packages' }
    function _function_files { service=pacman; words=(-Q $words); _pacman "$@" }
elif (( $+commands[dpkg] )); then
    function files {
        name="$1"
        if [ $# = 1 ]; then
            dpkg -L "$name"
        else
            shift
            dpkg -L "$name" | xargs grep --color=auto "$@"
        fi
    }
    function _function_files { _arguments '*:package:_deb_packages installed' }
fi
compdef _function_files files

#endregion

# ---------------------------

[ -e ~/.zshrc ] && . ~/.zshrc
