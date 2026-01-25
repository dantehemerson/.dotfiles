return {

  -- Animation on cursor movement
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = false,
  },
  -- {
  --   "snacks.nvim",
  --   opts = {
  --     scroll = { enabled = false },
  --   },
  -- },
  {

    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    cond = vim.g.neovide == nil,
    opts = {
      hide_target_hack = true,
      cursor_color = "none",
    },
    specs = {
      -- disable mini.animate cursor
      {
        "nvim-mini/mini.animate",
        optional = true,
        opts = {
          cursor = { enable = false },
        },
      },
    },
  },

  -- Coloscheme imports
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "Mofiqul/vscode.nvim", lazy = false, priority = 1000 },
  { "sainnhe/everforest", lazy = true },
  {
    "AlexvZyl/nordic.nvim",
    lazy = true,
  },
  {
    "navarasu/onedark.nvim",
    lazy = true,
    config = function()
      require("onedark").setup({
        style = "warmer",
      })
    end,
  },

  -- Colorscheme:
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
