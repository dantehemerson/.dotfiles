return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},

		keys = {
			-- 	{
			-- 		"<leader>,",
			-- 		"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
			-- 		desc = "Switch Buffer",
			-- 	},
			-- 	{
			-- 		"<leader>ff",
			-- 		"<cmd>Telescope find_files<cr>",
			-- 		desc = "Find files (Root Dir)",
			-- 	},
			-- 	{
			-- 		"<leader>/",
			-- 		"<cmd>Telescope live_grep<cr>",
			-- 		desc = "Live grep",
			-- 	},
			-- 	{
			-- 		"<leader>fb",
			-- 		"<cmd>Telescope buffers<cr>",
			-- 		desc = "Buffers",
			-- 	},
			-- 	{
			-- 		"<leader>fh",
			-- 		"<cmd>Telescope help_tags<cr>",
			-- 		desc = "Help tags",
			-- 	},
			{
				"<leader>thd",
				function()
					require("config.themes").pick_dark()
				end,
				desc = "Dark themes",
			},
			{
				"<leader>thl",
				function()
					require("config.themes").pick_light()
				end,
				desc = "Light themes",
			},
		},

		config = function()
			require("telescope").setup({
				defaults = {

					prompt_prefix = "   ",
					selection_caret = " ",
					entry_prefix = "  ",
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
						},
						width = 0.87,
						height = 0.80,
					},
					mappings = {
						n = { ["q"] = require("telescope.actions").close },
					},
				},
				extensions_list = { "themes", "terms" },
				extensions = {},
			})
		end,
	},
}
