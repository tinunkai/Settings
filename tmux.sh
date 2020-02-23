#!/bin/bash
set -x

rm -rf $HOME/.tmux
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
cp ./tmux.conf $HOME/.tmux.conf
