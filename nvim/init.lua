-- 1. Lazy.nvim Bootstrap (Keep this at the top)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Setup Plugins
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

  -- Icons (Required for nvim-tree)
  { "nvim-tree/nvim-web-devicons" },

  -- nvim-tree File Manager
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              git = true,
            },
            glyphs = {
              git = {
                unstaged = "󰄱",
                staged = "󰱒",
                unmerged = "󰡖",
                renamed = "󰁕",
                untracked = "󰈄",
                deleted = "󰛇",
                ignored = "◌",
              },
            },
          },
        },
        view = {
          width = 35,
          side = "left",
        },
      })
    end,
  },
  -- 1. Gitsigns: Shows +/-/modifications in the "sign column" (left of line numbers)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        current_line_blame = true, -- Shows who wrote the line (Ghost text)
        signs = {
          add          = { text = '▎' },
          change       = { text = '▎' },
          delete       = { text = '' },
          topdelete    = { text = '' },
          changedelete = { text = '▎' },
        },
      })
    end
  },

  -- 2. Fugitive: The best Git wrapper (for :Git commit, :Git push, etc.)
  { "tpope/vim-fugitive" },
})
-- 3. General Settings (Add these AFTER the plugin setup)
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.termguicolors = true

-- 4. Keymaps
vim.keymap.set('n', '<C-h>', ':NvimTreeFocus<CR>', { silent = true })
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })
-- Redirect :q to :qa only when NvimTree is the active window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    -- This makes it so if you type ':q' it executes ':qa'
    vim.cmd("cabbrev <buffer> q qa")
    vim.cmd("cabbrev <buffer> wq wqa")
    
    -- Also handles the 'q' and 'wq' keys without the colon
    vim.keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "wq", ":wqa<CR>", { buffer = true, silent = true })
  end
})
