source ~/dotfiles/znap/zsh-snap/znap.zsh
# function znap {
#     echo "znap $*"
# }

# -----------------------------------------
#region prefs

alias ls="ls --color"
alias l="ls -la --group-directories-first"
alias tiga="tig --all"
alias svim="sudo -E vim"

#endregion

# -----------------------------------------
#region prezto utility useful stuff

function mkcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}
#endregion

# -----------------------------------------

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
  echo "nope $0 $*"
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
setopt CORRECT

# Grep
if is-callable 'dircolors'; then
  eval "$(dircolors --sh $HOME/.dir_colors(N))"
fi

#endregion

# -----------------------------------------

# znap source 'piec/fzf-prezto' 'init.zsh'

path+=~/dotfiles/bin

# TODO runcoms?

# prompt
fpath=($HOME/dotfiles/zsh/functions/ $fpath)
autoload -Uz promptinit && promptinit
prompt fade2 magenta