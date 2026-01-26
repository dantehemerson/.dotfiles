local colorscheme_file = vim.fn.stdpath("state") .. "/colorscheme"

-- Save whenever the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.fn.writefile({ vim.g.colors_name }, colorscheme_file)
  end,
})

-- Restore on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.filereadable(colorscheme_file) == 1 then
      local cs = vim.fn.readfile(colorscheme_file)[1]
      pcall(vim.cmd.colorscheme, cs)
    end
  end,
})
