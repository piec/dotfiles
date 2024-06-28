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

znap source 'piec/dotfiles' \
    '.zsh/.zprezto/modules/helper/init.zsh' \
    \
    '.zsh/.zprezto/modules/environment/init.zsh' \
    '.zsh/.zprezto/modules/terminal/init.zsh' \
    '.zsh/.zprezto/modules/editor/init.zsh' \
    '.zsh/.zprezto/modules/history/init.zsh' \
    '.zsh/.zprezto/modules/directory/init.zsh' \
    '.zsh/.zprezto/modules/spectrum/init.zsh' \
    '.zsh/.zprezto/modules/completion/init.zsh' \
    '.zsh/.zprezto/modules/prompt/init.zsh' \
    '.zsh/.zprezto/modules/syntax-highlighting/init.zsh' \
    '.zsh/.zprezto/modules/command-not-found/init.zsh' \
    '.zsh/.zprezto/modules/autosuggestions/init.zsh' \

    # '.zsh/.zprezto/modules/utility/init.zsh' \
    # '.zsh/.zprezto/modules/bundle/init.zsh' \

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

znap source 'piec/fzf-prezto' 'init.zsh'


# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

path+=~/dotfiles/bin

# TODO runcoms?