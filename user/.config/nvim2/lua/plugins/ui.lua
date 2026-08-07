return {
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = false,
		},
		config = function()
			vim.cmd.colorscheme("vscode")
		end,
	},
}
