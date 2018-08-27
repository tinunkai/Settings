"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/tinunkai/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/tinunkai/.cache/dein')
  call dein#begin('/home/tinunkai/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/tinunkai/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('flazz/vim-colorschemes')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/denite.nvim')
  call dein#add('tpope/vim-sensible')
  call dein#add('rust-lang/rust.vim')
  call dein#add('JuliaEditorSupport/julia-vim')
  call dein#add('vim-syntastic/syntastic')
  call dein#add('danchoi/elinks.vim')
  call dein#add('isRuslan/vim-es6')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/deol.nvim', { 'rev': '01203d4c9' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------

set background=light
let g:solarized_termtrans=1
colorscheme solarized
syntax enable
set nu
set ts=4
set sw=4
set expandtab
set cursorcolumn
set cursorline
set colorcolumn=96
set statusline+=%F
nnoremap <C-t> :wa<CR>:!make <CR>
nnoremap <C-c> :w<CR>:SyntasticCheck<CR>
nnoremap <C-j> :lnext<CR>
nnoremap <C-k> :lprev<CR>
nnoremap <esc> :noh<CR>
"set printoptions=number:y

