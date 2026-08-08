return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",

		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},

		keys = {
			{
				"<leader>,",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{
				"<leader><leader>",
				"<cmd>Telescope find_files<cr>",
				desc = "Find files (Root Dir)",
			},
			{
				"<leader>/",
				"<cmd>Telescope live_grep<cr>",
				desc = "Live grep",
			},
			{
				"<leader>fb",
				"<cmd>Telescope buffers<cr>",
				desc = "Buffers",
			},
			{
				"<leader>fh",
				"<cmd>Telescope help_tags<cr>",
				desc = "Help tags",
			},
		},
	},
}
