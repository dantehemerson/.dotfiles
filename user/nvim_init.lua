-- Basic UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"


-- Make Nvim look terminal like
vim.opt.termguicolors = true
vim.opt.background = "dark"
--vim.cmd.colorscheme("industry:")

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.opt.relativenumber = true
  end,
})

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Behavior
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Clipboard (works on Windows)
vim.opt.clipboard = "unnamedplus"

-- Leader key
vim.g.mapleader = " "

-- Small keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- Highlight yanked text (tiny QoL)
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})
