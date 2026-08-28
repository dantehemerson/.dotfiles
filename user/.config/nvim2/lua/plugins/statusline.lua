return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "",
        section_separators = "",
      },

      sections = {
        lualine_a = { { "mode", icon = "", color = { gui = "bold" } } },
        lualine_b = { { "branch", icon = "" } },
        lualine_c = {
          {
            "filetype",
            icon_only = true,
            colored = false,
            padding = { left = 1, right = 0 },
            fmt = function(str)
              return str ~= "" and str or " "
            end,
          },
          {
            "filename",
            file_status = true,
            gui = "bold",
            path = 4,
            padding = { left = 0, right = 1 },
            symbols = {
              modified = '',
              readonly = '',
              unnamed = '[No Name]',
              newfile = '[New]',
            }
          },
        },

        lualine_x = {
          { "progress" },
          { "location" }
        },
        lualine_y = {
        },
        lualine_z = {
          {
            function()
              local name = vim.uv.cwd()
              name = name:match("([^/\\]+)[/\\]*$") or name
              return name
            end,
            -- separator = {
            --   left = "",
            -- },
            icon = "󰉖",
            padding = {
              left = 1,
              right = 1,
            },
            cond = function()
              return vim.o.columns > 85
            end,
            color = "lualine_b_normal"
            -- color = { gui = "normal" }
            -- color = function()
            --   return { fg = hi("Normal", "bg"), bg = "darkgray", gui = "bold" }
            -- end,
          },
        },
      },
    })
  end,
}
