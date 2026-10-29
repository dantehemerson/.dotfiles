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
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true  -- Case-sensitive search when using capitals
vim.opt.tabstop = 2       -- Display a tab as 2 spaces wide
vim.opt.softtabstop = 2   -- Tab/Backspace behave like 2 spaces
vim.opt.shiftwidth = 2    -- Indentation width
vim.opt.expandtab = true  -- Use spaces instead of actual tab characters
vim.opt.hlsearch = true   -- Highlight search matches
vim.opt.incsearch = true  -- Show matches while typing a search
vim.opt.showmode = false  -- Don't show mode (e.g. -- INSERT --)
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  -- space = "·",
}

-- Enable undo/redo changes even after closing and reopening a file
vim.opt.undofile = true

vim.diagnostic.config({
  -- Show diagnostic text to the right, only on the current line
  virtual_text = {
    current_line = true,
  },

  -- Don't show diagnostics below the line
  virtual_lines = false,

  -- Don't underline the problematic code
  underline = false,

  signs = true,
  update_in_insert = false,
  severity_sort = true,

  float = {
    border = "rounded",
    source = "if_many",
    height = 12,
    width = 80,
  },

  -- Remove the diagnostic sign (text) and highlight the line number instead.
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      -- [vim.diagnostic.severity.ERROR] = "",
      -- [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.WARN] = "",
      -- [vim.diagnostic.severity.INFO] = "󰋽",
      [vim.diagnostic.severity.INFO] = "",
      -- [vim.diagnostic.severity.HINT] = "󰌶",
      [vim.diagnostic.severity.HINT] = "",
    },
    -- text = {
    --   [vim.diagnostic.severity.ERROR] = '',
    --   [vim.diagnostic.severity.WARN] = '',
    --   [vim.diagnostic.severity.INFO] = '',
    --   [vim.diagnostic.severity.HINT] = '',
    -- },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
      [vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint",
    },
  },
})

vim.opt.cmdheight = 0
-- Show recording line while using it
vim.cmd([[ autocmd RecordingEnter * set cmdheight=1 ]])
vim.cmd([[ autocmd RecordingLeave * set cmdheight=0 ]])

vim.opt.shortmess:append("W")

vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"
