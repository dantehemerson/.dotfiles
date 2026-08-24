return {
	{
		"sphamba/smear-cursor.nvim",
		opts = {
			stiffness = 0.8,
			trailing_stiffness = 0.6,
			stiffness_insert_mode = 0.7,
			trailing_stiffness_insert_mode = 0.7,
			damping = 0.95,
			damping_insert_mode = 0.95,
			distance_stop_animating = 0.5,
		},
	},
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
		},
	},
}
