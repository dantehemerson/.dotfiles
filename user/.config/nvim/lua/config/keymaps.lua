-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Copy reference to the selection
local function yank_file_reference()
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local filepath = vim.fn.expand("%:.") -- path relative to cwd
	local ref
	if start_line == end_line then
		ref = string.format("@%s#L%d", filepath, start_line)
	else
		ref = string.format("@%s#L%d-%d", filepath, start_line, end_line)
	end

	vim.fn.setreg("+", ref)
	vim.notify("Copied reference: " .. ref)
end

vim.keymap.set("v", "<leader>yr", yank_file_reference, { desc = "Yank file reference (@path#Lx-y)" })
