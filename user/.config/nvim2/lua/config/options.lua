vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Enable undo/redo changes even after closing and reopening a file
vim.opt.undofile = true

vim.keymap.set("n", "<leader>r", "<cmd>source $MYVIMRC<cr>", { desc = "Reload config" })

-- Netrw Default Explorer
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altfile = 1

vim.keymap.set("n", "<leader>e", ":Lexplore<cr>", { silent = true })

-- netrw's built-in `%` opens new files in the netrw window instead of
-- respecting `netrw_browse_split`. Override it to open in the previous window.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		vim.keymap.set("n", "%", function()
			local fname = vim.fn.input("Enter filename: ")
			if fname == "" then
				return
			end

			local dir = vim.b.netrw_curdir or vim.fn.getcwd()
			local path = dir .. "/" .. fname

			if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
				vim.notify("Already exists: " .. fname, vim.log.levels.WARN)
				return
			end

			if fname:match("/$") then
				vim.fn.mkdir(path, "p")
				vim.cmd("edit")
			else
				local f = io.open(path, "w")
				if not f then
					vim.notify("Failed to create: " .. fname, vim.log.levels.ERROR)
					return
				end
				f:close()

				local escaped = vim.fn.fnameescape(path)
				if vim.fn.winnr("#") == 0 then
					vim.cmd("edit " .. escaped)
				else
					vim.cmd("wincmd p")
					vim.cmd("edit " .. escaped)
				end
			end
		end, { buffer = true, silent = true, noremap = true, desc = "Create file in previous window" })
	end,
})
