return {
	"nvim-lualine/lualine.nvim",
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
				lualine_b = { "filename" },
				lualine_c = { { "branch", icon = "" } },
				lualine_y = { "progress" },
				lualine_z = {
					"location",
					{
						function()
							local icon = " "
							local name = vim.uv.cwd()
							name = name:match("([^/\\]+)[/\\]*$") or name
							return icon .. "" .. name
						end,
						cond = function()
							return vim.o.columns > 85
						end,
						color = function()
							return { fg = hi("Normal", "bg"), bg = hi("Error"), gui = "bold" }
						end,
					},
				},
			},
		})
	end,
}
