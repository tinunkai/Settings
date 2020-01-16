#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

alias info='info --vi-keys'
alias vi=vim
alias vim='nvim'
alias vimdiff='nvim -d'
alias tig='tig --all'
alias bc='bc -l'
alias def='ydcv'
alias coin='coinmon -f mona -c jpy'
alias open='xdg-open'
alias dstat='dstat -am'
alias sl=ls
alias iv=vi
alias say=espeak

export KEYTIMEOUT=1
export EDITOR='nvim'
export VISUAL='nvim'
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^K' kill-whole-line
bindkey -M viins '^W' backward-delete-word
bindkey -M vicmd '^V' edit-command-line
bindkey -M emacs '^V' edit-command-line

wttr()
{
    # change Paris to your default location
    local request="wttr.in/${1-kashiwara}"
    request+='?qAF&lang=zh'
    [ "$COLUMNS" -lt 125 ] && request+='&n'
    curl --compressed "$request"
}

PATH=$PATH:$HOME/.local/bin
