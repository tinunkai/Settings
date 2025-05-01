-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvim setup
require("lazy").setup({
  {
    'nvim-orgmode/orgmode',
    event = {'BufReadPre', 'BufNewFile'},
    config = function()
      -- Setup orgmode
      require('orgmode').setup({
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',
      })
    end,
  },
  { "RRethy/nvim-base16" },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        highlight = { enable = true },
        ignore_install ={ "org" },
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-vsnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'path' }
        }, {
          { name = 'buffer' }
        }),
      })
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{ name = 'buffer' }}
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({{ name = 'path' }}, {{ name = 'cmdline' }})
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )
      lspconfig.ruff.setup {
        capabilities = capabilities,
      }
    end
  },
  -- { "github/copilot.vim" },
  { "SeniorMars/typst.nvim" },
  { "onerobotics/vim-karel" },
  { "tweekmonster/django-plus.vim" },
  {
    "mxw/vim-jsx",
    dependencies = { "pangloss/vim-javascript" },
  },
  {
    "tinunkai/startup.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("startup").setup {
        theme = "evil"
      }
    end
  },
  { "wakatime/vim-wakatime" },
})

-- General Settings
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "iso-2022-jp", "euc-jp", "sjis" }
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.g.mapleader = " "

-- Appearance
vim.cmd [[
colorscheme base16-tomorrow-night
set colorcolumn=119
set cursorline
set cursorcolumn
set mouse=
]]

-- Keymaps
vim.cmd [[
nnoremap <Leader>w <cmd>Telescope live_grep<cr>
nnoremap <Leader>p <cmd>Telescope find_files<cr>
nnoremap <Leader>e <cmd>Telescope diagnostics<cr>

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap zi :set fdm=syntax<CR>
nnoremap zp :set fdm=indent<CR>
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
]]

-- Autocommands
vim.cmd [[
autocmd FileType tex inoremap <silent> \bb \begin{equation}<CR>\end{equation}<Esc>ko
autocmd FileType tex inoremap <silent> \tb \textbf{<Esc>a
autocmd FileType tex inoremap <silent> \mr \mathrm{<Esc>a
autocmd FileType tex inoremap <silent> _max _{\mathrm{max}}<Esc>a
autocmd FileType tex inoremap <silent> _min _{\mathrm{min}}<Esc>a

autocmd FileType vimscript,javascript,javascriptreact,json,jinja,css,html,htmldjango,typescript,markdown,tex,lua,karel set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType c,cpp,cuda,python,dosbatch set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType go set tabstop=4|set shiftwidth=4
autocmd FileType make set tabstop=4|set shiftwidth=4
autocmd BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set ft=htmldjango
autocmd BufNewFile,BufRead *.js set ft=javascriptreact
]]

-- END
