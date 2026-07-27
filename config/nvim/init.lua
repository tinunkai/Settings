vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.fileencodings = { "utf-8", "cp932", "iso-2022-jp", "euc-jp", "sjis" }
vim.opt.fileformats = { "unix", "dos" }
vim.opt.colorcolumn = "119"
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.mouse = ""

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvim setup
require("lazy").setup({
  {
    "nvim-orgmode/orgmode",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("orgmode").setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
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
    "nvim-mini/mini.diff",
    version = false,
    config = function()
      require("mini.diff").setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local nts = require("nvim-treesitter")
      local treesitter_group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })

      nts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      nts.install({
        "markdown",
        "markdown_inline",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "c",
        "cpp",
        "cuda",
        "python",
        "javascript",
        "typescript",
        "json",
        "html",
        "css",
        "go",
        "typst",
      })

      vim.treesitter.language.register("html", "htmldjango")

      vim.api.nvim_create_autocmd("FileType", {
        group = treesitter_group,
        pattern = {
          "markdown",
          "lua",
          "vim",
          "vimdoc",
          "c",
          "cpp",
          "cuda",
          "python",
          "javascript",
          "javascriptreact",
          "typescript",
          "json",
          "html",
          "htmldjango",
          "css",
          "go",
          "typst",
        },
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      vim.lsp.config("ruff", {
        capabilities = capabilities,
      })

      vim.lsp.config("clangd", {
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        root_markers = {
          ".clangd",
          ".clang-tidy",
          ".clang-format",
          "compile_commands.json",
          "compile_flags.txt",
          ".git",
        },
      })

      vim.lsp.enable("ruff")
      vim.lsp.enable("clangd")
    end,
  },

  -- { "github/copilot.vim" },

  { "onerobotics/vim-karel" },

  {
    "tinunkai/startup.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("startup").setup({
        theme = "evil",
      })
    end,
  },

  { "wakatime/vim-wakatime" },
})

vim.diagnostic.enable(false)

local config_group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = config_group,
  callback = function(args)
    local lsp_map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, {
        buffer = args.buf,
        desc = desc,
        silent = true,
      })
    end

    lsp_map("gd", vim.lsp.buf.definition, "Go to definition")
    lsp_map("gD", vim.lsp.buf.declaration, "Go to declaration")
    lsp_map("gr", vim.lsp.buf.references, "List references")
    lsp_map("gi", vim.lsp.buf.implementation, "Go to implementation")
    lsp_map("K", vim.lsp.buf.hover, "Show hover information")
    lsp_map("<leader>E", function()
      vim.diagnostic.open_float(nil, {
        scope = "line",
        border = "rounded",
        source = "if_many",
      })
    end, "Show line diagnostics")
  end,
})

-- Appearance
vim.api.nvim_cmd({
  cmd = "colorscheme",
  args = { "base16-tomorrow-night" },
}, {})

-- Keymaps
local map = vim.keymap.set

local telescope = function(picker)
  return function()
    require("telescope.builtin")[picker]()
  end
end

map("n", "<leader>g", function()
  require("mini.diff").toggle_overlay()
end, {
  desc = "Toggle diff overlay",
})

map("n", "<leader>w", telescope("live_grep"), { desc = "Live grep" })
map("n", "<leader>p", telescope("find_files"), { desc = "Find files" })
map("n", "<leader>e", telescope("diagnostics"), { desc = "List diagnostics" })
map("n", "<leader>ff", telescope("find_files"), { desc = "Find files" })
map("n", "<leader>fg", telescope("live_grep"), { desc = "Live grep" })
map("n", "<leader>fb", telescope("buffers"), { desc = "List buffers" })
map("n", "<leader>fh", telescope("help_tags"), { desc = "Search help" })

map("n", "zi", function()
  vim.opt_local.foldmethod = "syntax"
end, { desc = "Use syntax folds" })
map("n", "zp", function()
  vim.opt_local.foldmethod = "indent"
end, { desc = "Use indent folds" })

map("n", "<C-c>", function()
  local source_window = vim.api.nvim_get_current_win()

  vim.api.nvim_cmd({ cmd = "wall" }, {})
  vim.api.nvim_cmd({ cmd = "split" }, {})
  vim.api.nvim_set_current_win(source_window)
  vim.api.nvim_cmd({ cmd = "terminal" }, {})
  vim.api.nvim_chan_send(vim.b.terminal_job_id, "make\n")
end, { desc = "Save all and run make in a split" })

map("n", "<C-j>", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<C-k>", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<C-n>", "<cmd>tab split<cr>", { desc = "Open buffer in new tab" })
map("i", "<C-o>", "<Esc>", { desc = "Leave insert mode" })
map("t", "<C-o>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight", silent = true })

for _, mapping in ipairs({
  { "j", "gj" },
  { "k", "gk" },
  { "0", "g0" },
  { "$", "g$" },
  { "^", "g^" },
  { "gj", "j" },
  { "gk", "k" },
  { "g0", "0" },
  { "g$", "$" },
  { "g^", "^" },
}) do
  map("n", mapping[1], mapping[2])
end

-- Autocommands
vim.filetype.add({
  extension = {
    html = "htmldjango",
    htm = "htmldjango",
    shtml = "htmldjango",
    stm = "htmldjango",
    js = "javascriptreact",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  group = config_group,
  pattern = "tex",
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }

    map("i", "\\bb", "\\begin{equation}<CR>\\end{equation}<Esc>ko", opts)
    map("i", "\\tb", "\\textbf{<Esc>a", opts)
    map("i", "\\mr", "\\mathrm{<Esc>a", opts)
    map("i", "_max", "_{\\mathrm{max}}<Esc>a", opts)
    map("i", "_min", "_{\\mathrm{min}}<Esc>a", opts)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = config_group,
  pattern = {
    "vim",
    "javascript",
    "javascriptreact",
    "json",
    "jinja",
    "css",
    "html",
    "htmldjango",
    "typescript",
    "markdown",
    "tex",
    "lua",
    "karel",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = config_group,
  pattern = { "c", "cpp", "cuda", "python", "dosbatch" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = config_group,
  pattern = { "go", "make" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end,
})

-- END
