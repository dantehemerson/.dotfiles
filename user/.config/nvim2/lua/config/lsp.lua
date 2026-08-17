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
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Go to references"))
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Show hover"))
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))

		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, opts("Previous diagnostic"))

		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, opts("Next diagnostic"))
	end,
})
