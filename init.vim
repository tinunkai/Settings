"dein Scripts-----------------------------
if &compatible
    set nocompatible                             " Be iMproved
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
    call dein#add('chriskempson/base16-vim')
    call dein#add('itchyny/lightline.vim')
    call dein#add('Shougo/denite.nvim')
    call dein#add('rust-lang/rust.vim')
    call dein#add('Shougo/deoplete.nvim')
    call dein#add('sebastianmarkow/deoplete-rust')
    call dein#add('neovimhaskell/haskell-vim')
    call dein#add('mechatroner/rainbow_csv')
    call dein#add('lepture/vim-jinja')
    call dein#add('wakatime/vim-wakatime')
    call dein#add('MaxMEllon/vim-jsx-pretty')
    call dein#add('vim-scripts/vbnet.vim')
    call dein#add('LnL7/vim-nix')
    call dein#add('lervag/vimtex')
    call dein#add('jceb/vim-orgmode')
    call dein#add('vim-python/python-syntax')

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
call deoplete#enable()

"End dein Scripts-------------------------

"Denite Settings--------------------------
call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

nmap <silent> <Space>t :<C-u>DeniteProjectDir filetype<CR>
nmap <silent> <Space>p :<C-u>DeniteProjectDir file/rec<CR>
nmap <silent> <Space>l :<C-u>DeniteProjectDir line<CR>
nmap <silent> <Space>g :<C-u>DeniteProjectDir grep<CR>
nmap <silent> <Space>] :<C-u>DeniteCursorWord grep<CR>
"nmap <silent> <Space><C-u> :<C-u>Denite file_mru<CR>
"nmap <silent> <Space><C-y> :<C-u>Denite neoyank<CR>
nmap <silent> <Space>r :<C-u>DeniteProjectDir -resume<CR>
nmap <silent> <Space>; :<C-u>DeniteProjectDir -resume -immediately -select=+1<CR>
nmap <silent> <Space>, :<C-u>DeniteProjectDir -resume -immediately -select=-1<CR>

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction
"End Denite Settings----------------------

colorscheme base16-tomorrow-night
set termguicolors
syntax enable

set nonu
set ts=4
set sw=4
set colorcolumn=91
set expandtab
set cursorcolumn
set cursorline
set statusline+=%F
set printoptions=portrait:n

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
let g:lightline = {'colorscheme': 'Tomorrow_Night'}
let g:python_highlight_all = 1
let g:vimtex_indent_enabled = 0

nnoremap zi :set fdm=indent<CR>
nnoremap <C-t> :wa<CR>:sp<CR><C-W>j:terminal<CR>i
"nnoremap <C-c> :wa<CR>:sp<CR><C-W>j:terminal<CR>i make<CR><C-\><C-n>G<C-w>k
nnoremap <C-c> :wa<CR>:sp<CR><C-W>j:terminal<CR>i make<CR>
nnoremap <C-j> :tabn<CR>
nnoremap <C-k> :tabp<CR>
inoremap <C-o> <Esc>
tnoremap <C-o> <C-\><C-n>
nnoremap <C-n> :tab sp<CR>
"nnoremap <C-g> :%!gpg -as<CR>
nnoremap <C-s> :wa<CR>:sp<CR><C-W>j:terminal sml %<CR>i
nnoremap <silent> <esc> :noh<CR>
nnoremap j gj
nnoremap k gk
nnoremap 0 g0
nnoremap $ g$
nnoremap ^ g^
nnoremap gj j
nnoremap gk k
nnoremap g0 0
nnoremap g$ $
nnoremap g^ ^
set linebreak
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac

autocmd FileType javascript set tabstop=2|set shiftwidth=2|set expandtab|set ft=typescript
autocmd FileType javascriptreact set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType json set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType jinja set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType css set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType html set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType htmldjango set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType typescript set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType tex set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType tex inoremap <silent> \bb \begin{equation}<CR>\end{equation}<Esc>ko
autocmd FileType tex inoremap <silent> \tb \textbf{<Esc>a
autocmd FileType tex inoremap <silent> \mr \mathrm{<Esc>a
autocmd FileType tex inoremap <silent> _max _{\mathrm{max}}<Esc>a
autocmd FileType tex inoremap <silent> _min _{\mathrm{min}}<Esc>a
autocmd FileType tex set autoindent&
autocmd FileType tex set cindent&
autocmd FileType tex set smartindent&
autocmd FileType tex set indentexpr&
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set ft=jinja
au BufNewFile,BufRead *.cls set ft=vbnet
