vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local function opts(desc)
			desc = desc or ""
			return {
				buffer = event.buf,
				desc = "LSP " .. desc,
			}
		end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts())
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts())

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts())
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts())
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts())

		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, opts())

		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, opts())
	end,
})
