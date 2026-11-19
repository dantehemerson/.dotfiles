vim.loader.enable()

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.themes")
require("config.lazy")
require("config.lsp")
-- Persisted theme choice (written by lua/config/themes.lua when picking a
-- theme). Missing on a fresh install, so don't fail the rest of the config.
pcall(require, "current-theme")
