local theme_file = vim.fn.stdpath("config") .. "/lua/current-theme.lua"

local M = {}

M.common_exclude = {
   "default",
  "vim",
  "retrobox",
  "sorbet",
  "wildcharm",
  "zaibatsu",
  "desert",
  "evening",
  "industry",
  "koehler",
  "morning",
  "murphy",
  "pablo",
  "peachpuff",
  "ron",
  "shine",
  "slate",
  "torte",
  "zellner",
  "blue",
  "darkblue",
  "delek",
  "quiet",
  "elflord",
  "habamax",
  "lunaperche",
  "unokai",
}

M.exclude_from_dark = {
	"vimbones",
	"kanagawa-lotus",
	"morning",
	"peachpuff",
	"shine",
	"zellner",
	"dawnfox",
	"delek",
}

M.exclude_from_light = {
	"blue",
	"darkblue",
	"carbonfox",
	"desert",
	"duckbones",
	"duskfox",
	"elflord",
	"evening",
	"habamax",
	"industry",
	"kanagawa-dragon",
	"kanagawa-wave",
	"kanagawabones",
	"koehler",
	"miasma",
	"murphy",
	"nordbones",
	"nordfox",
	"pablo",
	"rasmus",
	"ron",
	"slate",
	"sorbet",
	"terafox",
	"tokyonight-moon",
	"tokyonight-storm",
	"tokyonight-night",
	"zaibatsu",
	"vim",
	"unokai",
	"torte",
	"zenburned",
	"nightfox",
	"randombones",
}

M.exclude_terms_from_dark = {
	"light",
	"day",
}

M.exclude_terms_from_light = {
	"dark",
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

local function get_themes(excluded, excluded_terms)
	local themes = vim.fn.getcompletion("", "color", true)

	local excluded_set = {}
	for _, theme in ipairs(excluded or {}) do
		excluded_set[theme] = true
	end

	local excluded_terms_list = excluded_terms or {}

	return vim.tbl_filter(function(theme)
		if excluded_set[theme] then
			return false
		end
		for _, term in ipairs(excluded_terms_list) do
			if theme:lower():find(term:lower(), 1, true) then
				return false
			end
		end
		return true
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

local function pick(title, excluded, excluded_terms, background)
	local themes = get_themes(excluded, excluded_terms)
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
					vim.opt.background = background
					actions.move_selection_next(prompt_bufnr)
					set_theme()
				end)
				map("i", "<Up>", function()
					vim.opt.background = background
					actions.move_selection_previous(prompt_bufnr)
					set_theme()
				end)
				map("i", "<CR>", function()
					vim.opt.background = background
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
	pick(
		"Dark Themes",
		vim.list_extend(vim.deepcopy(M.common_exclude), M.exclude_from_dark),
		vim.list_extend(vim.deepcopy(M.common_exclude), M.exclude_terms_from_dark),
		"dark"
	)
end

function M.pick_light()
	pick(
		"Light Themes",
		vim.list_extend(vim.deepcopy(M.common_exclude), M.exclude_from_light),
		vim.list_extend(vim.deepcopy(M.common_exclude), M.exclude_terms_from_light),
		"light"
	)
end

return M
