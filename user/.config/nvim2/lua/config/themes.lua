local theme_file = vim.fn.stdpath("config") .. "/lua/current-theme.lua"
local favorites_file = vim.fn.stdpath("config") .. "/lua/favorite-themes.lua"

local M = {}

local function read_favorites()
  if vim.fn.filereadable(favorites_file) ~= 1 then
    return {}
  end
  local ok, result = pcall(dofile, favorites_file)
  if ok and type(result) == "table" then
    return result
  end
  return {}
end

local function write_favorites(list)
  local entries = {}
  for _, t in ipairs(list) do
    table.insert(entries, string.format("%q", t))
  end
  vim.fn.writefile({ "return { " .. table.concat(entries, ", ") .. " }" }, favorites_file)
end

local function toggle_favorite(theme)
  local favs = read_favorites()
  local new_favs = {}
  local is_fav = false
  for _, t in ipairs(favs) do
    if t == theme then
      is_fav = true
    else
      table.insert(new_favs, t)
    end
  end
  if not is_fav then
    table.insert(new_favs, theme)
  end
  write_favorites(new_favs)
  return not is_fav
end

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

  -- zenbones-theme/zenbones.nvim
  "kanagawabones",
  "randombones",
  "tokyobones",
  "seoulbones",
  "duckbones",
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
  "catppuccin-latte"
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
  "blackout",
  "moss",
  "dusk",
  "frost",
  "blossom",
  "ember",
  "velvet",
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
  local entry = action_state.get_selected_entry()
  if not entry or not entry.value then
    return
  end
  pcall(vim.cmd.colorscheme, entry.value)
end

-- Write config to `current-theme.lua` to persist theme
local write_config = function()
  local action_state = require("telescope.actions.state")
  local entry = action_state.get_selected_entry()
  if not entry or not entry.value then
    return
  end
  local file = assert(io.open(theme_file, "w"))

  local current_background = vim.o.background or "dark"
  file:write('vim.opt.background = "' .. current_background .. '"\n')
  file:write('vim.cmd("colorscheme ' .. entry.value .. '")\n')
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
  local action_state = require("telescope.actions.state")

  local favorites = read_favorites()
  local favorites_set = {}
  for _, f in ipairs(favorites) do
    favorites_set[f] = true
  end

  local results = themes
  local entry_maker = function(theme)
    local is_fav = favorites_set[theme]
    return {
      value = theme,
      display = is_fav and ("fav: " .. theme) or theme,
      ordinal = is_fav and ("fav " .. theme) or theme,
    }
  end

  local old_theme = vim.g.colors_name or "default"
  local old_background = vim.opt.background or "dark"

  local default_selection_index = 1
  for i, theme in ipairs(themes) do
    if theme == old_theme then
      default_selection_index = i
      break
    end
  end

  local function apply_current()
    vim.opt.background = background
    set_theme()
  end

  require("telescope.pickers")
      .new({}, {
        prompt_title = title,
        default_selection_index = default_selection_index,
        selection_strategy = "row",

        finder = require("telescope.finders").new_table({
          results = results,
          entry_maker = entry_maker,
        }),

        sorter = require("telescope.config").values.generic_sorter({}),

        previewer = get_previewer(),

        attach_mappings = function(prompt_bufnr, map)
          local picker = action_state.get_current_picker(prompt_bufnr)

          picker:register_completion_callback(apply_current)

          map("i", "<Down>", function()
            actions.move_selection_next(prompt_bufnr)
            apply_current()
          end)
          map("i", "<Up>", function()
            actions.move_selection_previous(prompt_bufnr)
            apply_current()
          end)
          map("i", "<C-a>", function()
            local entry = action_state.get_selected_entry()
            if not entry or not entry.value then
              return
            end
            local saved_row = picker:get_selection_row()

            local now_fav = toggle_favorite(entry.value)
            favorites_set[entry.value] = now_fav
            if now_fav then
              entry.display = "fav: " .. entry.value
              entry.ordinal = "fav " .. entry.value
            else
              entry.display = entry.value
              entry.ordinal = entry.value
            end

            local previous_callbacks = vim.list_extend({}, picker._completion_callbacks or {})
            picker:register_completion_callback(function(p)
              p._completion_callbacks = previous_callbacks
              if p.manager then
                p:set_selection(saved_row)
              end
            end)

            picker:refresh()
            vim.notify(now_fav and ("★ " .. entry.value) or ("☆ " .. entry.value))
          end)
          map("i", "<CR>", function()
            apply_current()
            write_config()
            actions.close(prompt_bufnr)
          end)
          map("i", "<ESC>", function()
            vim.cmd("colorscheme " .. old_theme)
            vim.opt.background = old_background
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
