#!/bin/bash
set -x

rm -rf $HOME/.local/share/nvim
rm -rf $HOME/.config/nvim
rm -rf $HOME/.init.vim
rm -rf $HOME/.init.lua
rm -rf $HOME/.plugins.lua
mkdir -p $HOME/.config/nvim

cp nvim.init.lua $HOME/.config/nvim/init.lua
ln -s $HOME/.config/nvim/init.lua $HOME/.init.lua
