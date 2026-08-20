return {
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		config = function()
			require("telescope").load_extension("lazygit")

			vim.api.nvim_create_autocmd("TermEnter", {
				pattern = "term://*lazygit*",
				callback = function()
					vim.keymap.set("t", "<Esc>", "<C-c><cmd>q<cr>", { buffer = 0, desc = "LazyGit: quit" })
				end,
			})
		end,
	},
}
