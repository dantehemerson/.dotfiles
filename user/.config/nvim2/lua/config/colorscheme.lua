local theme_file = vim.fn.stdpath("config") .. "/lua/current-theme.lua"

-- Save whenever the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.fn.writefile({ string.format("vim.cmd.colorscheme(%q)", vim.g.colors_name) }, theme_file)
	end,
})
