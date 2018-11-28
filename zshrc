#setxkbmap -option ctrl:nocaps
#oh-my-zsh---------------------------------------------------------------
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="dst"

plugins=(git)
#plugins=(vi-mode)

source $ZSH/oh-my-zsh.sh

#custom------------------------------------------------------------------
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

export KEYTIMEOUT=1
export EDITOR='nvim'
bindkey -M vicmd ' ' edit-command-line
bindkey -v

weather()
{
	curl wttr.in/$1
}

source /usr/bin/aws_zsh_completer.sh

PATH=$PATH:/home/tinunkai/android-studio/bin


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

