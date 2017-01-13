export ZSH=$HOME/.zplug/repos/robbyrussell/oh-my-zsh

ZSH_THEME="af-magic"

plugins=(git colored-man-pages)

source $ZSH/oh-my-zsh.sh
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "zsh-users/zaw"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
	echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

#rmmod pcspkr

PATH=$PATH:./:$(ruby -e 'print Gem.user_dir')/bin

alias vi='vim'
alias tig='tig --all'
alias bc='bc -l'
alias def='sdcv -n'
alias tmux='tmux -2'
alias python='python3'

weather()
{
	curl wttr.in/$1
}
deff()
{
	sdcv -n $1 | less;
}

