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
