return {
  -- Themes:
  { "Mofiqul/vscode.nvim" },
  { "folke/tokyonight.nvim" },
  { "rebelot/kanagawa.nvim" },

  { "sainnhe/gruvbox-material" },
  { "projekt0n/github-nvim-theme", name = "github-theme" },
  { "EdenEast/nightfox.nvim" },
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
  },
  {
    "AvengeMedia/base46",
    opts = {
      nvchad = {
        cmp_style = "atom_colored",
        telescope_style = "borderless",
        statusline_theme = nil
      }
    }
  },
  {
    "harshrajsachan/omni.nvim",
  },
}
