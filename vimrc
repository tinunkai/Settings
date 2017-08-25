"NeoBundle Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=$HOME/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('$HOME/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'tpope/vim-sensible'
NeoBundle 'rust-lang/rust.vim'

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

set background=dark
let g:solarized_termtrans=1
colorscheme solarized
syntax enable
set nu
set ts=4
set sw=4
set expandtab
set cursorcolumn
set cursorline
set colorcolumn=72
nnoremap <C-t> :wa<CR>:!make <CR>

