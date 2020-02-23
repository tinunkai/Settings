#!/usr/bin/env zsh
set -x

rm -rf $HOME/.zprezto $HOME/.zlogin $HOME/.zlogout $HOME/.zpreztorc $HOME/.zprofile $HOME/.zshenv $HOME/.zshrc

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

cp zsh/zshrc $HOME/.zshrc
cp zsh/zpreztorc $HOME/.zpreztorc

