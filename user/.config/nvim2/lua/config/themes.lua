local theme_file = vim.fn.stdpath("config") .. "/lua/current-theme.lua"

local M = {}

M.exclude_from_dark = {
	"catppuccin-latte",
	"everforest-light",
}

M.exclude_from_light = {
	"tokyonight",
	"gruvbox",
}

local set_theme = function()
	local action_state = require("telescope.actions.state")
	vim.cmd("colorscheme " .. action_state.get_selected_entry()[1])
end

-- Write config to `current-theme.lua` to persist theme
local write_config = function()
	local action_state = require("telescope.actions.state")
	local selected = action_state.get_selected_entry()[1]
	local file = assert(io.open(theme_file, "w"))

	file:write('vim.cmd("colorscheme ' .. selected .. '")')
	file:close()
end

local function get_themes(excluded)
	local themes = vim.fn.getcompletion("", "color", true)

	local excluded_set = {}
	for _, theme in ipairs(excluded) do
		excluded_set[theme] = true
	end

	return vim.tbl_filter(function(theme)
		return not excluded_set[theme]
	end, themes)
end

-- Provide buffer previewer with syntax highlighting
local get_previewer = function()
	local previewers = require("telescope.previewers")

	local bufnr = vim.api.nvim_get_current_buf()

	return previewers.new_buffer_previewer({
		define_preview = function(self, _)
			-- Add content
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

			-- Syntax highlighting
			local ft = (vim.filetype.match({ buf = bufnr }) or "diff"):match("%w+")
			require("telescope.previewers.utils").highlighter(self.state.bufnr, ft)
		end,
	})
end

local function pick(title, excluded)
	local themes = get_themes(excluded)
	local actions = require("telescope.actions")

	local old_theme = vim.g.colors_name or "default"

	require("telescope.pickers")
		.new({}, {
			prompt_title = title,

			finder = require("telescope.finders").new_table({
				results = themes,
			}),

			sorter = require("telescope.config").values.generic_sorter({}),

			previewer = get_previewer(),

			attach_mappings = function(prompt_bufnr, map)
				map("i", "<Down>", function()
					actions.move_selection_next(prompt_bufnr)
					set_theme()
				end)
				map("i", "<Up>", function()
					actions.move_selection_previous(prompt_bufnr)
					set_theme()
				end)
				map("i", "<CR>", function()
					set_theme()
					write_config()
					actions.close(prompt_bufnr)
				end)
				map("i", "<ESC>", function()
					vim.cmd("colorscheme " .. old_theme)
					actions.close(prompt_bufnr)
				end)
				return true
			end,
		})
		:find()
end

function M.pick_dark()
	vim.opt.background = "dark"
	pick("Dark Themes", M.exclude_from_dark)
end

function M.pick_light()
	vim.opt.background = "light"
	pick("Light Themes", M.exclude_from_light)
end

return M
