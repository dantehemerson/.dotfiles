vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()

		if vim.v.event.operator == "y" then
			vim.fn.setreg("+", vim.fn.getreg('"'))
		end
	end,
})

vim.api.nvim_create_augroup("AutoFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = "AutoFormatting",
	callback = function()
		vim.lsp.buf.format({ async = true })
	end,
})
