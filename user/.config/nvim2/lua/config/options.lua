vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.laststatus = 3 -- global statusline
vim.opt.showmode = false
vim.opt.guicursor = "n-v-c:block-blinkwait700-blinkoff400-blinkon250,i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250"
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true  -- Don't ignore case with capitals
vim.opt.tabstop = 2       -- Number of spaces tabs count for
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmode = false


-- Enable undo/redo changes even after closing and reopening a file
vim.opt.undofile = true

-- vim.diagnostic.config({ virtual_text = true }) -- inline diagnostics
vim.diagnostic.config({
  virtual_text = false,

  virtual_lines = {
    current_line = true,
  },

  signs = true,

  underline = true,

  update_in_insert = false,

  severity_sort = true,

  float = {
    border = "rounded",
    source = "if_many",
    height = 12,
    width = 80,
  },
})

vim.opt.cmdheight = 0
-- Show recording line while using it
vim.cmd [[ autocmd RecordingEnter * set cmdheight=1 ]]
vim.cmd [[ autocmd RecordingLeave * set cmdheight=0 ]]

vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"
