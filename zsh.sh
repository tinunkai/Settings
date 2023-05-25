#!/usr/bin/env zsh
set -x

rm -rf $HOME/.zprezto $HOME/.zlogin $HOME/.zlogout $HOME/.zpreztorc $HOME/.zprofile $HOME/.zshenv $HOME/.zshrc $HOME/.zplug

# zplug
git clone https://github.com/zplug/zplug $HOME/.zplug

cp zsh/zshrc $HOME/.zshrc
mkdir -p $HOME/.config
cp zsh/main.omp.json $HOME/.config
