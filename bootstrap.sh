#!/usr/bin/env bash
set -ex
set -o noclobber

if [ "$1" = "backup" ]; then
    mkdir -p backup
    backup=".vimrc .vim .tmux.conf .tmux.number.sh .tmux.local .zshenv .gitconfig"
    for f in $backup; do
        if [ -e "$f" ]; then
            mv -v "$f" backup/
        fi
    done
fi

cd
if ! [ -e dotfiles ]; then
    git clone --recursive git@github.com:piec/dotfiles dotfiles
fi

ln -s dotfiles/.vimrc
ln -s dotfiles/.vim

ln -s dotfiles/tmux/.tmux.conf
ln -s dotfiles/tmux/.tmux.number.sh
touch ~/.tmux.local

cat > ~/.zshenv <<EOF
ZDOTDIR="\$HOME/dotfiles/.zsh"
[ -e "\$ZDOTDIR/.zshenv" ] && . "\$ZDOTDIR/.zshenv"
EOF

cat > ~/.gitconfig <<EOF
[user]
    ;email = ...

[include]
    path = ~/dotfiles/.gitconfig
EOF

if [ -e ~/.bash_history ] && ! [ -e ~/.zhistory ] ; then
    cp -v ~/.bash_history ~/.zhistory
fi

mkdir -p ~/.config
ln -s ~/dotfiles/redshift/redshift.conf ~/.config/

ln -s ~/dotfiles/i3 ~/.config/
ln -s ~/dotfiles/i3status-rust/ ~/.config/
ln -s ~/dotfiles/starship/starship.toml ~/.config/
