autoload -U select-word-style
select-word-style bash
export WORDCHARS='.-'

setopt autocd

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*' menu select
bindkey '^[[Z' reverse-menu-complete

alias info='info --vi-keys'
alias vi=nvim
alias vimdiff='nvim -d'
alias em='emacs -nw'
alias tig='tig --all'
alias bc='bc -l'
alias open='xdg-open'
alias dstat='dstat -am'
alias ls='ls --color'
alias say=espeak
alias matrix='cmatrix -ab -u 3'
alias vm='vmstat -t -S M 1'
alias luaf='lua-format --indent-width=2 -i'

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export KEYTIMEOUT=1
export EDITOR='vi'
export VISUAL='vi'
export TERM='xterm-256color'

bindkey -v
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^K' kill-whole-line
bindkey -M viins '^W' backward-delete-word
bindkey -M vicmd '^V' edit-command-line
bindkey -M emacs '^V' edit-command-line

# export PATH=/home/tinunkai/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib # for wsl
export PATH=$HOME/.pyenv/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH

eval "$(pyenv init -)"
# source $HOME/.cargo/env

PROMPT="%F{yellow}===%f %(?.%K{green}%F{black}%.%f%k.%K{red}%?%k) at %F{blue}%m%f %F{yellow}===%f "
