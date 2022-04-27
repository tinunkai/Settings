#!/bin/bash
set -x

rm -rf $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/nvim/lua
cp ./nvim/init.lua $HOME/.config/nvim/init.lua
cp ./nvim/plugins.lua $HOME/.config/nvim/lua/plugins.lua
ln -s $HOME/.config/nvim/init.lua $HOME/.init.lua
ln -s $HOME/.config/nvim/lua/plugins.lua $HOME/.plugins.lua
