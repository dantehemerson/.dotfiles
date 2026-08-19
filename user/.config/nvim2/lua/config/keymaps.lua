-- Swap between split buffers
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, remap = true, desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, remap = true, desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, remap = true, desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, remap = true, desc = "Move to right split" })
