return {
  {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",

    opts = {
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh",
        },
        default_icon = { color = "#6c7689", icon = "󰈚", name = "Default" },
        js = { color = "#f7df1e", icon = "󰌞", name = "js" },
        ts = { color = "#3178c6", icon = "󰛦", name = "ts" },
        lock = { color = "#f7c97c", icon = "󰌾", name = "lock" },
        ["robots.txt"] = { color = "#9ca3af", icons = "󰚩", name = "robots" },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      statuscolumn = { enabled = true },
      image = { enabled = true },
      quickfile = { enabled = true }
    },
    keys = {
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP Workspace Symbols",
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit (Root Dir)",
      },
    },
  },
}
