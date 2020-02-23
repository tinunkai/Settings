#!/bin/bash
set -x

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm installer.sh

mkdir -p $HOME/.config/nvim
cp ./init.vim $HOME/.config/nvim/init.vim
ln -s $HOME/.config/nvim/init.vim $HOME/.init.vim

