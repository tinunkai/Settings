vim.cmd 'packadd packer.nvim'

return require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}
  use 'chriskempson/base16-vim'
  use 'itchyny/lightline.vim'
  use 'racer-rust/vim-racer'
  use 'nvim-treesitter/nvim-treesitter'
  use {
    --'nvim-orgmode/orgmode',
    'tinunkai/orgmode',
    config = function() require('orgmode').setup {} end
  }
end)
