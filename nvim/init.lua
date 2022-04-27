require 'plugins'

vim.api.nvim_set_option('termguicolors', true)
vim.api.nvim_set_option('cursorcolumn', true)
vim.api.nvim_set_option('cursorline', true)

vim.api.nvim_set_option('printoptions', 'portrait:n')
vim.api.nvim_set_option('ts', 4)
vim.api.nvim_set_option('sw', 4)
vim.api.nvim_set_option('expandtab', true)
vim.api.nvim_set_option('colorcolumn', '96')
vim.api.nvim_set_option('encoding', 'utf-8')
vim.api.nvim_set_option('fileencodings', 'utf-8,iso-2022-jp,euc-jp,sjis')
vim.api.nvim_set_option('fileformats', 'unix,dos,mac')
vim.api.nvim_set_var('mapleader', 'm')

vim.cmd [[
autocmd BufWritePost plugins.lua,.plugins.lua call Packin()
function Packin()
  PackerInstall
  PackerUpdate
  PackerCompile
endfunction

nnoremap zi :set fdm=syntax<CR>
nnoremap <C-t> :wa<CR>:sp<CR><C-W>j:terminal<CR>i
nnoremap <C-c> :wa<CR>:sp<CR><C-W>j:terminal<CR>i make<CR>
nnoremap <C-j> :tabn<CR>
nnoremap <C-k> :tabp<CR>
inoremap <C-o> <Esc>
tnoremap <C-o> <C-\><C-n>
nnoremap <C-n> :tab sp<CR>
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

autocmd FileType tex inoremap <silent> \bb \begin{equation}<CR>\end{equation}<Esc>ko
autocmd FileType tex inoremap <silent> \tb \textbf{<Esc>a
autocmd FileType tex inoremap <silent> \mr \mathrm{<Esc>a
autocmd FileType tex inoremap <silent> _max _{\mathrm{max}}<Esc>a
autocmd FileType tex inoremap <silent> _min _{\mathrm{min}}<Esc>a

autocmd FileType vimscript,javascript,javascriptreact,json,jinja,css,html,htmldjango,typescript,markdown,org,tex,lua set tabstop=2|set shiftwidth=2|set expandtab
autocmd BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set ft=jinja

colorscheme base16-tomorrow-night
]]

require'orgmode'.setup_ts_grammar()

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {'org'},
    additional_vim_regex_highlighting = {'org'}
  },
  ensure_installed = {'org'},
  ensure_installed = {'python'},
  ensure_installed = {'rust'},
  ensure_installed = {'lua'}
}

require'orgmode'.setup({mappings = {org = {org_toggle_checkbox = '<Leader>c'}}})

-- Setup nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
  snippet = {expand = function(args) vim.fn["vsnip#anonymous"](args.body) end},
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    {name = 'nvim_lsp'}, {name = 'vsnip'}, {name = 'orgmode'}, {name = 'path'}
  }, {{name = 'buffer'}})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    {name = 'cmp_git'} -- You can specify the `cmp_git` source if you were installed it.
  }, {{name = 'buffer'}})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {{name = 'buffer'}}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                     .protocol
                                                                     .make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {capabilities = capabilities}
