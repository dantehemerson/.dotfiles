return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    -- Optional: configure global options (like a custom install directory if needed)
    require("nvim-treesitter").setup({
      -- install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Install your desired parsers (including typescript and tsx)
    require("nvim-treesitter").install({
      "c",
      "cpp",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "javascript",
      "python",
      "typescript",
      "tsx",
      "rust",
      "bash",
    })

    -- Turn on Treesitter highlighting for all files
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
