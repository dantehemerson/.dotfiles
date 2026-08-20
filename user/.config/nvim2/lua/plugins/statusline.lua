return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local function hi(group, attr)
			attr = attr or "fg"
			local h = vim.api.nvim_get_hl(0, { name = group, link = false })
			return string.format("#%06x", h[attr] or 0xffffff)
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = "",
				section_separators = "",
			},

			sections = {
				lualine_a = { { "mode", icon = "" } },
				lualine_b = {
					{
						"filetype",
						icon_only = true,
						padding = { left = 1, right = 0 },
						fmt = function(str)
							return str ~= "" and str or " "
						end,
					},
					{ "filename", file_status = true, path = 1, padding = { left = 0, right = 1 } },
				},
				lualine_c = { { "branch", icon = "" } },

				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{ "progress", color = { fg = "gray", bg = "NONE" } },
					{ "location", color = { fg = "gray", bg = "NONE" } },
					{
						function()
							local name = vim.uv.cwd()
							name = name:match("([^/\\]+)[/\\]*$") or name
							return name
						end,
						separator = {
							left = "",
						},
						icon = "󰉖",
						padding = {
							left = 0,
							right = 1,
						},
						cond = function()
							return vim.o.columns > 85
						end,
						color = function()
							return { fg = hi("Normal", "bg"), bg = "darkgray", gui = "bold" }
						end,
					},
				},
			},
		})
	end,
}
