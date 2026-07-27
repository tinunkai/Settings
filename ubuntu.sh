#!/usr/bin/env bash
set -Eeuo pipefail

readonly packages=(
    make
    build-essential
    libssl-dev
    zlib1g-dev
    libbz2-dev
    libreadline-dev
    libsqlite3-dev
    wget
    curl
    llvm
    libncurses5-dev
    xz-utils
    tk-dev
    libxml2-dev
    libxmlsec1-dev
    libffi-dev
    liblzma-dev
    zsh
    software-properties-common
)

sudo apt-get update
sudo apt-get install --no-install-recommends -y "${packages[@]}"
sudo snap install nvim --classic
