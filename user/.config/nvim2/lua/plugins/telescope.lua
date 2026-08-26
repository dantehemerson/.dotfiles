return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		lazy = false,
		keys = {
			{
				"<leader>,",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true selection_strategy=reset<cr>",
				desc = "Switch Buffer",
			},
			{ "<leader>:",  "<cmd>Telescope command_history<cr>",           desc = "Command History" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer Lines" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>",               desc = "Diagnostics" },
			{ "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>",       desc = "Buffer Diagnostics" },
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
			local telescope = require("telescope")
			telescope.setup({
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
					path_display = {
						"filename_first",
					},
					mappings = {
						n = { ["q"] = require("telescope.actions").close },
					},
				},
				extensions = {
					["ui-select"] = {
						-- require("telescope.themes").get_dropdown({})
					}
				},
			})

			telescope.load_extension("ui-select")
		end,
	},
}
