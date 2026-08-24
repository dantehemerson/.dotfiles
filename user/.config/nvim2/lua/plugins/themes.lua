return {
	-- Themes:
	{ "Mofiqul/vscode.nvim" },
	{ "folke/tokyonight.nvim" },
	{ "rebelot/kanagawa.nvim" },
	{ "morhetz/gruvbox" },
	{ "sainnhe/gruvbox-material" },
	{ "projekt0n/github-nvim-theme", name = "github-theme" },
	{
		"xero/miasma.nvim",
	},
	{ "kvrohit/rasmus.nvim" },
	{ "EdenEast/nightfox.nvim" },
	{
		"zenbones-theme/zenbones.nvim",
		dependencies = "rktjmp/lush.nvim",
	},
	{
		"fraeso/xcodedark.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("xcodedark").setup({
				transparent = false,
				integrations = {
					telescope = true,
					nvim_tree = true,
					gitsigns = true,
					bufferline = true,
					incline = true,
					lazygit = true,
					which_key = true,
					notify = true,
					snacks = true,
					blink = true,
				},

				terminal_colors = true,
			})
			vim.cmd.colorscheme("xcodedark")
		end,
	},
}
