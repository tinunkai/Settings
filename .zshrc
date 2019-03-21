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

autoload -Uz promptinit
promptinit
prompt paradox

# Customize to your needs...
alias info='info --vi-keys'
alias vi=vim
alias vim='nvim'
alias vimdiff='nvim -d'
alias tig='tig --all'
alias bc='bc -l'
alias def='ydcv'
alias tmux='tmux -2'
alias coin='coinmon -f mona -c jpy'
alias diff='vimdiff'
alias open='xdg-open'
alias dstat='dstat -am'
alias sl=ls
alias iv=vi
alias say=espeak

export KEYTIMEOUT=1
export EDITOR='nvim'
bindkey -v
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


source /usr/bin/aws_zsh_completer.sh

PATH=$PATH:/home/tinunkai/android-studio/bin
PATH=$PATH:/home/tinunkai/.bin


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
