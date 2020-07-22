" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'tpope/vim-sensible'
Plug 'chriskempson/base16-vim'

" Initialize plugin system
call plug#end()

colorscheme base16-default-dark

set ts=4
set sw=4
set expandtab
