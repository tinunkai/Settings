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
NeoBundle 'JuliaEditorSupport/julia-vim'
NeoBundle 'vim-syntastic/syntastic'

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_w = 0
let g:syntastic_javascript_checker = ['eslint']

"End NeoBundle Scripts-------------------------

set background=light
let g:solarized_termtrans=1
colorscheme solarized
syntax enable
set nu
set ts=2
set sw=2
set expandtab
set cursorcolumn
set cursorline
set colorcolumn=96
set statusline+=%F
nnoremap <C-t> :wa<CR>:!make <CR>
nnoremap <C-c> :w<CR>:SyntasticCheck<CR>
nnoremap <C-j> :lnext<CR>
nnoremap <C-k> :lprev<CR>

