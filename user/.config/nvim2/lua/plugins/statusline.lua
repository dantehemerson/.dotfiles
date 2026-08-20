return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = "",
				section_separators = "",
			},

			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = { "filename" },
				lualine_y = { "progress" },
				lualine_z = {
					"location",
					{
						function()
							local icon = "󰉋 "
							local name = vim.uv.cwd()
							name = name:match("([^/\\]+)[/\\]*$") or name
							return icon .. " " .. name
						end,
						cond = function()
							return vim.o.columns > 85
						end,
					},
				},
			},
		})
	end,
}
