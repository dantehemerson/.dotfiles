return {
	{
		"andrew-george/telescope-themes",
		config = function()
			require("telescope").setup({
				extensions = {
					themes = {
						-- allow default/builtin schemes (don't ignore them)
						--						ignore = false,
					},
				},
			})

			require("telescope").load_extension("themes")

			vim.keymap.set(
				"n",
				"<leader>th",
				":Telescope themes<CR>",
				{ noremap = true, silent = true, desc = "Theme Switcher" }
			)
		end,
	},

	-- Themes:
	{ "Mofiqul/vscode.nvim" },
	{ "folke/tokyonight.nvim" },
	{ "rebelot/kanagawa.nvim" },
	{ "morhetz/gruvbox" },
	{ "sainnhe/gruvbox-material" },
	{ "projekt0n/github-nvim-theme", name = "github-theme" },
	{
		"rockyzhang24/arctic.nvim",
		dependencies = { "rktjmp/lush.nvim" },
	},
	{
		"xero/miasma.nvim",
	},
	{ "kvrohit/rasmus.nvim" },
	{ "Tsuzat/NeoSolarized.nvim", opts = {
		style = "dark",
		transparent = false,
	} },
	{ "EdenEast/nightfox.nvim" },
	{
		"zenbones-theme/zenbones.nvim",
		dependencies = "rktjmp/lush.nvim",
	},
}
