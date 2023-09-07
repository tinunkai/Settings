#!/usr/bin/env zsh
set -x

rm -rf $HOME/.zprezto $HOME/.zlogin $HOME/.zlogout $HOME/.zpreztorc $HOME/.zprofile $HOME/.zshenv $HOME/.zshrc $HOME/.zplug
mkdir -p $HOME/.config

cp zshrc $HOME/.zshrc
