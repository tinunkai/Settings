vim.cmd 'packadd packer.nvim'

return require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}
  use 'chriskempson/base16-vim'
  use 'itchyny/lightline.vim'
  use 'racer-rust/vim-racer'
  use 'nvim-treesitter/nvim-treesitter'

  use 'neovim/nvim-lspconfig'
  use 'tweekmonster/django-plus.vim'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    }
  }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  use {
    -- 'nvim-orgmode/orgmode',
    'tinunkai/orgmode',
    config = function() require'orgmode'.setup {} end
  }
end)
