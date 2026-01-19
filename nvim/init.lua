-- 1. SET LEADER KEY FIRST (Crucial for plugins to recognize Space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Lazy.nvim Bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Setup Plugins
require("lazy").setup({
  -- Everblush Theme
  {
    "Everblush/nvim",
    name = "everblush",
    priority = 1000,
    config = function()
      require("everblush").setup({
        transparent_background = false,
        nvim_tree = { contrast = true },
      })
      vim.cmd.colorscheme("everblush")
    end,
  },

  -- outline
  {
  "hedyhli/outline.nvim",
  config = function()
    -- Example mapping to toggle outline
    vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>",
      { desc = "Toggle Outline" })

    require("outline").setup {
      -- Your setup opts here (leave empty to use defaults)
    }
  end,
},
  -- Icons
  { "nvim-tree/nvim-web-devicons" },

  -- nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = { enable = true, update_root = true },
        renderer = {
          highlight_git = true,
          icons = {
            glyphs = {
              git = {
                unstaged = "󰄱", staged = "󰱒", unmerged = "󰡖",
                renamed = "󰁕", untracked = "󰈄", deleted = "󰛇", ignored = "◌",
              },
            },
          },
        },
        view = { width = 35, side = "left" },
      })
    end,
  },

  -- barbar
  {
    'romgrk/barbar.nvim',
    dependencies = { 'lewis6991/gitsigns.nvim', 'nvim-tree/nvim-web-devicons' },
    init = function() vim.g.barbar_auto_setup = false end,
    version = '^1.0.0',
  },

  -- lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require('lualine').setup() end,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,
        signs = {
          add = { text = '▎' }, change = { text = '▎' },
          delete = { text = '' }, topdelete = { text = '' }, changedelete = { text = '▎' },
        },
      })
    end
  },

  -- Fugitive
  { "tpope/vim-fugitive" },
}) -- FIXED: Added missing closing bracket and parenthesis

-- 4. General Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- 5. Keymaps
vim.keymap.set('n', '<C-h>', ':NvimTreeFocus<CR>', { silent = true })
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })

-- Auto-close/Quit logic for NvimTree
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.cmd("cabbrev <buffer> q qa")
    vim.cmd("cabbrev <buffer> wq wqa")
    vim.keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "wq", ":wqa<CR>", { buffer = true, silent = true })
  end
})
