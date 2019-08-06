"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('rafi/awesome-vim-colorschemes')

  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

  call dein#add('Shougo/denite.nvim')
  call dein#add('tpope/vim-sensible')
  call dein#add('rust-lang/rust.vim')
  call dein#add('JuliaEditorSupport/julia-vim')
  "call dein#add('danchoi/elinks.vim')
  call dein#add('isRuslan/vim-es6')
  call dein#add('udalov/kotlin-vim')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('itchyny/lightline.vim')
  call dein#add('leafgarland/typescript-vim')
  call dein#add('sebastianmarkow/deoplete-rust')
  call dein#add('posva/vim-vue')
  call dein#add('sirtaj/vim-openscad')
  call dein#add('neovimhaskell/haskell-vim')

  " You can specify revision/branch/tag.
  "call dein#add('Shougo/deol.nvim', { 'rev': '01203d4c9' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" dein autocalls
call dein#add('neomake/neomake')
" call neomake#configure#automake('rw')

"End dein Scripts-------------------------

"Denite Settings--------------------------
call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

nmap <silent> <Space>t :<C-u>DeniteProjectDir filetype<CR>
nmap <silent> <Space>p :<C-u>DeniteProjectDir file_rec<CR>
nmap <silent> <Space>l :<C-u>DeniteProjectDir line<CR>
nmap <silent> <Space>g :<C-u>DeniteProjectDir grep<CR>
nmap <silent> <Space>] :<C-u>DeniteCursorWord grep<CR>
"nmap <silent> <Space><C-u> :<C-u>Denite file_mru<CR>
"nmap <silent> <Space><C-y> :<C-u>Denite neoyank<CR>
nmap <silent> <Space>r :<C-u>DeniteProjectDir -resume<CR>
nmap <silent> <Space>; :<C-u>DeniteProjectDir -resume -immediately -select=+1<CR>
nmap <silent> <Space>, :<C-u>DeniteProjectDir -resume -immediately -select=-1<CR>
"End Denite Settings----------------------

set background=dark
"let g:solarized_termtrans=1
"let g:airline_theme='papercolor'
"let g:lightline = { 'colorscheme': 'PaperColor' }
"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
colorscheme gruvbox
syntax enable
hi Search cterm=NONE ctermfg=white ctermbg=magenta
let g:deoplete#enable_at_startup = 1

set nu
set ts=4
set sw=4
set expandtab
set cursorcolumn
set cursorline
set colorcolumn=100
set statusline+=%F
set printoptions=portrait:n

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

nnoremap zi :set fdm=indent<CR>
nnoremap <C-t> :wa<CR>:sp<CR><C-W>j:terminal<CR>i
nnoremap <C-c> :wa<CR>:sp<CR><C-W>j:terminal make<CR>i
nnoremap <C-j> :lnext<CR>
nnoremap <C-k> :lprev<CR>
nnoremap <Esc> :noh<CR>
inoremap <C-o> <Esc>
tnoremap <C-o> <C-\><C-n>
nnoremap <C-n> :tab sp<CR>
nnoremap <C-g> :%!gpg -as<CR>

autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType javascript set tabstop=2|set shiftwidth=2|set expandtab|set ft=typescript
autocmd FileType json set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType html set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType typescript set tabstop=2|set shiftwidth=2|set expandtab

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
