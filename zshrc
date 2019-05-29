source $HOME/.zplug/init.zsh

zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "zsh-users/zaw", use:"zaw.zsh"
zplug "sorin-ionescu/prezto", hook-build:'ln -s $HOME/.zplug/repos/sorin-ionescu/prezto $HOME/.zprezto'

# cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook is-at-least
if is-at-least 4.3.10; then
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
fi

zplug load #--verbose

# custom

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
export VISUAL='nvim'
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^K' kill-whole-line
bindkey -M viins '^W' backward-delete-word
bindkey -M vicmd '^V' edit-command-line
bindkey -M emacs '^V' edit-command-line

bindkey '^@' zaw-cdr
bindkey '^R' zaw-history

wttr()
{
    # change Paris to your default location
    local request="wttr.in/${1-kashiwara}"
    request+='?qAF&lang=zh'
    [ "$COLUMNS" -lt 125 ] && request+='&n'
    curl --compressed "$request"
}

PATH=$PATH:$HOME/.local/bin
