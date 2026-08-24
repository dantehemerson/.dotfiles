return {
	{
		"dmtrKovalenko/fff",
		build = function()
			-- downloads a prebuilt binary or falls back to cargo build
			require("fff.download").download_or_build_binary()
		end,
		opts = {
			prompt = "   ",
			title = "Files",
			layout = {
				prompt_position = "top",
				border = "rounded",
			},
		},
		lazy = false, -- the plugin lazy-initialises itself
		keys = {
			{
				"<leader>ff",
				function()
					require("fff").find_files()
				end,
				desc = "Find files",
			},
			{
				"<leader>/",
				function()
					require("fff").live_grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fz",
				function()
					require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
				end,
				desc = "Live fuzzy grep",
			},
			{
				"<leader>fw",
				function()
					require("fff").live_grep_under_cursor()
				end,
				mode = { "n", "x" },
				desc = "Search current word / selection",
			},
		},
	},
	{
		"vinitkumar/fff-plus.nvim",
		dependencies = { "dmtrKovalenko/fff" },
		opts = {
			legacy_commands = false,
		},
		keys = {
			{
				"<leader>,",
				function()
					require("fff_plus").buffers()
					vim.schedule(function()
						local state = require("fff_plus.pickers.buffers").state
						-- Move down to select the previous buffer
						if state and state.active then
							state:move("down")
						end
					end)
				end,
				desc = "Switch Buffer",
			},
		},
	},
}
