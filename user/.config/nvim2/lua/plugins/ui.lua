local scrollbar_color = vim.o.background == "dark"
    and "#ffffff"
    or "#000000";

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
  {
    "petertriho/nvim-scrollbar",
    opts = {
      hide_if_all_visible = true,
      handle = {
        text = " ",
        blend = 70,
        color = scrollbar_color,
        color_nr = "red",
        highlight = "blue",
      },
      marks = {
        Cursor = {
          text = "━"
        }
        ,
        GitAdd = {
          text = "▎",
          priority = 10,
        },
        GitChange = {
          text = "▎",
          priority = 9,
        },
        GitDelete = {
          text = "▎",
          priority = 10,
        },
      },
      handlers = {
        handle = true,
        cursor = true,
        diagnostic = false,
        gitsigns = true, -- Requires gitsigns
        search = false,  -- Requires hlslens
        ale = false,     -- Requires ALE
      }
    }
  }
}
