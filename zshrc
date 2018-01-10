#oh-my-zsh---------------------------------------------------------------
# Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="dst"

plugins=(git)

source $ZSH/oh-my-zsh.sh
#zplug-------------------------------------------------------------------
source $HOME/.zplug/init.zsh

#custom------------------------------------------------------------------
alias info='info --vi-keys'
alias vi='vim'
alias tig='tig --all'
alias bc='bc -l'
alias def='sdcv -n'
alias tmux='tmux -2'

weather()
{
	curl wttr.in/$1
}
deff()
{
	sdcv -n $1 | less;
}

export PATH=$HOME/bin:$HOME/.cargo/bin:/usr/local/bin:$HOME/anaconda3/bin:$PATH
