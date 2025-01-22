vim.cmd 'packadd packer.nvim'

return require('packer').startup(function()
  use 'SeniorMars/typst.nvim'
  use 'onerobotics/vim-karel'
  use {'wbthomason/packer.nvim', opt = true}
  use 'RRethy/nvim-base16'
  use 'nvim-lualine/lualine.nvim'
  use 'racer-rust/vim-racer'
  use 'nvim-treesitter/nvim-treesitter'
  use 'neovim/nvim-lspconfig'
  use 'kyazdani42/nvim-web-devicons'
  use 'github/copilot.vim'

  use {
    "tinunkai/startup.nvim",
    requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
  }

  use 'tweekmonster/django-plus.vim'
  use {
    'mxw/vim-jsx',
    requires = {
      'pangloss/vim-javascript'
    }
  }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'wakatime/vim-wakatime'
end)
