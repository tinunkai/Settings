#!/bin/bash
set -x

cp -r ./rime $HOME/.local/share/fcitx5
cd $HOME/.local/share/fcitx5/rime && make
