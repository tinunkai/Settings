#!/usr/bin/env zsh
set -x

# set prezto for zsh
rm -rf $HOME/.zprezto $HOME/.zlogin $HOME/.zlogout $HOME/.zpreztorc $HOME/.zprofile $HOME/.zshenv $HOME/.zshrc

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

cp zsh/zshrc $HOME/.zshrc
cp zsh/zpreztorc $HOME/.zpreztorc

# dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm installer.sh

mkdir -p $HOME/.config/nvim
cp ./init.vim $HOME/.config/nvim/init.vim

# pyenv
curl https://pyenv.run | bash
