#!/bin/bash
set -u
set -e
set -x

link() {
	[ -e $1 ] && mv $1 dotfiles_sv/$1
	ln -s dotfiles/$1 $1
}

cd ~

[ ! -e dotfiles ]
git clone --recursive ssh://pierre@serv.thruhere.net/~pierre/git-repos/dotfiles dotfiles

if [ -e dotfiles_sv ]; then
	[ -d dotfiles_sv ]
else
	mkdir dotfiles_sv
fi

link .vim
link .vimrc

link .screenrc

#link .emacs
[ -e .emacs ] && mv .emacs dotfiles_sv/.emacs
link .emacs.d

link .toprc
link .htoprc

#export_line="export PATH=\$PATH:~/dotfiles/bin"
export_line="source ~/dotfiles/sub-bashrc"
if ! grep "$export_line" .bashrc ; then
	echo $export_line >> .bashrc
fi

