--Startup screen/navigation
return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		_Gopts = {
			position = "center",
			hl = "Type",
			wrap = "overflow",
		}

		-- DASHBOARD HEADER
		local fill = vim.fn.winheight(0) - 43
		local logo = (fill >= 0 and [[










    ]] or "") .. [[
                                          
       ███████████           █████      ██
      ███████████             █████ 
      ████████████████ ███████████ ███   ███████
     ████████████████ ████████████ █████ ██████████████
    █████████████████████████████ █████ █████ ████ █████
  ██████████████████████████████████ █████ █████ ████ █████
 ██████  ███ █████████████████ ████ █████ █████ ████ ██████
 ██████   ██  ███████████████   ██ █████████████████

      ]]

		-- Highlight groups configuration for each segment
		local header_hl = {}

		if fill >= 0 then
			table.insert(header_hl, { { "Red", 1, 1 } })
			table.insert(header_hl, { { "Red", 1, 1 } })
			table.insert(header_hl, { { "Red", 1, 1 } })
			table.insert(header_hl, { { "Red", 1, 1 } })
			table.insert(header_hl, { { "Red", 1, 1 } })
			table.insert(header_hl, { { "Red", 1, 1 } })
			table.insert(header_hl, { { "Red", 1, 1 } })
			table.insert(header_hl, { { "Red", 1, 1 } })
			table.insert(header_hl, { { "Red", 1, 1 } })
			table.insert(header_hl, { { "Red", 1, 1 } })
		end
		table.insert(header_hl, { { "AlphaHeader0_0", 46, 48 } }) -- Line 10
		table.insert(header_hl, { -- Line 11
			{ "AlphaHeader1_0", 7, 22 },
			{ "AlphaHeader1_1", 33, 40 },
			{ "AlphaHeader1_2", 40, 50 },
		})
		table.insert(header_hl, { -- Line 12
			{ "AlphaHeader2_0", 6, 21 },
			{ "AlphaHeader2_1", 33, 45 },
		})
		table.insert(header_hl, { -- Line 13
			{ "AlphaHeader3_0", 6, 19 },
			{ "AlphaHeader3_1", 19, 20 },
			{ "AlphaHeader3_2", 20, 35 },
			{ "AlphaHeader3_3", 35, 45 },
			{ "AlphaHeader3_4", 45, 90 },
		})
		table.insert(header_hl, { -- Line 14
			{ "AlphaHeader4_0", 5, 18 },
			{ "AlphaHeader4_1", 18, 36 },
			{ "AlphaHeader4_2", 36, 45 },
			{ "AlphaHeader4_3", 45, 90 },
		})
		table.insert(header_hl, { -- Line 15
			{ "AlphaHeader5_0", 4, 17 },
			{ "AlphaHeader5_1", 17, 24 },
			{ "AlphaHeader5_2", 24, 28 },
			{ "AlphaHeader5_3", 28, 37 },
			{ "AlphaHeader5_4", 37, 46 },
			{ "AlphaHeader5_5", 46, 90 },
		})
		table.insert(header_hl, { -- Line 16
			{ "AlphaHeader6_0", 2, 17 },
			{ "AlphaHeader6_1", 17, 38 },
			{ "AlphaHeader6_2", 38, 45 },
			{ "AlphaHeader6_3", 46, 90 },
		})
		table.insert(header_hl, { -- Line 17
			{ "AlphaHeader7_0", 1, 17 },
			{ "AlphaHeader7_1", 17, 38 },
			{ "AlphaHeader7_2", 38, 45 },
			{ "AlphaHeader7_3", 46, 90 },
		})
		table.insert(header_hl, { -- Line 18
			{ "AlphaHeader8_0", 1, 37 },
			{ "AlphaHeader8_1", 37, 91 },
		})

		vim.api.nvim_set_hl(0, "AlphaHeader0_0", { fg = "#a6c9ab" })
		vim.api.nvim_set_hl(0, "AlphaHeader1_0", { fg = "#bb7744" })
		vim.api.nvim_set_hl(0, "AlphaHeader1_1", { fg = "#386c3f" })
		vim.api.nvim_set_hl(0, "AlphaHeader1_2", { fg = "#a6c9ab" })
		vim.api.nvim_set_hl(0, "AlphaHeader2_0", { fg = "#be7d46" })
		vim.api.nvim_set_hl(0, "AlphaHeader2_1", { fg = "#3d7344" })
		vim.api.nvim_set_hl(0, "AlphaHeader3_0", { fg = "#c18250" })
		vim.api.nvim_set_hl(0, "AlphaHeader3_1", { fg = "#5c441e" })
		vim.api.nvim_set_hl(0, "AlphaHeader3_2", { fg = "#d6c383" })
		vim.api.nvim_set_hl(0, "AlphaHeader3_3", { fg = "#407b48" })
		vim.api.nvim_set_hl(0, "AlphaHeader3_4", { fg = "#98c09c" })
		vim.api.nvim_set_hl(0, "AlphaHeader4_0", { fg = "#c38950" })
		vim.api.nvim_set_hl(0, "AlphaHeader4_1", { fg = "#e0c785" })
		vim.api.nvim_set_hl(0, "AlphaHeader4_2", { fg = "#44844b" })
		vim.api.nvim_set_hl(0, "AlphaHeader4_3", { fg = "#a0c4a3" })
		vim.api.nvim_set_hl(0, "AlphaHeader5_0", { fg = "#c58f56" })
		vim.api.nvim_set_hl(0, "AlphaHeader5_1", { fg = "#e2cb85" })
		vim.api.nvim_set_hl(0, "AlphaHeader5_2", { fg = "#5c441e" })
		vim.api.nvim_set_hl(0, "AlphaHeader5_3", { fg = "#e2cb85" })
		vim.api.nvim_set_hl(0, "AlphaHeader5_4", { fg = "#488c51" })
		vim.api.nvim_set_hl(0, "AlphaHeader5_5", { fg = "#a6c9ab" })
		vim.api.nvim_set_hl(0, "AlphaHeader6_0", { fg = "#c7955b" })
		vim.api.nvim_set_hl(0, "AlphaHeader6_1", { fg = "#e3cf88" })
		vim.api.nvim_set_hl(0, "AlphaHeader6_2", { fg = "#4d9356" })
		vim.api.nvim_set_hl(0, "AlphaHeader6_3", { fg = "#aecdb3" })
		vim.api.nvim_set_hl(0, "AlphaHeader7_0", { fg = "#c89b62" })
		vim.api.nvim_set_hl(0, "AlphaHeader7_1", { fg = "#e5d38a" })
		vim.api.nvim_set_hl(0, "AlphaHeader7_2", { fg = "#509b59" })
		vim.api.nvim_set_hl(0, "AlphaHeader7_3", { fg = "#b7d1b9" })
		vim.api.nvim_set_hl(0, "AlphaHeader8_0", { fg = "#5c441e" })
		vim.api.nvim_set_hl(0, "AlphaHeader8_1", { fg = "#2e4e2a" })

		local utils = require("alpha.utils")

		local header_val = vim.split(logo, "\n")
		header_hl = utils.charhl_to_bytehl(header_hl, header_val, false)

		dashboard.section.header.opts.hl = header_hl
		dashboard.section.header.val = header_val
		-- Split logo into lines
		local logoLines = {}
		for line in logo:gmatch("[^\r\n]+") do
			table.insert(logoLines, line)
		end

		local init_path = vim.fn.stdpath("config")
		dashboard.section.buttons.val = {
			dashboard.button("n", "  New file", ":ene <BAR> startinsert<CR>"),
			dashboard.button("r", "󰄉  Recent files", ":Telescope recent_files<CR>"),
			dashboard.button("u", "󱐥  Update plugins", "<cmd>Lazy update<CR>"),
			dashboard.button(
				"c",
				"󰈞  Find file in C:",
				":cd C: | silent Telescope find_files hidden=true no_ignore=true <CR>"
			),
			dashboard.button(
				"d",
				"󰮗  Find file in D:",
				":cd D: | silent Telescope find_files hidden=true no_ignore=true <CR>"
			),
			dashboard.button("s", "  Settings", ":cd " .. init_path .. "<CR>:e init.lua<CR>"),
			dashboard.button("q", "󰿅  Quit", "<cmd>q<CR>"),
		}

		dashboard.section.buttons.opts.hl = "AlphaHeader1_0"

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			desc = "Add Alpha dashboard footer",
			once = true,
			callback = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
				dashboard.section.footer.val = {}
				if fill >= 0 then
					table.insert(dashboard.section.footer.val, "")
					table.insert(dashboard.section.footer.val, "")
					table.insert(dashboard.section.footer.val, "")
				end
				table.insert(
					dashboard.section.footer.val,
					" Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins  in " .. ms .. " ms "
				)
				for _ = 1, fill do
					table.insert(dashboard.section.footer.val, "")
				end
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
		-- Hide all the unnecessary visual elements while on the dashboard, and add
		-- them back when leaving the dashboard.
		local group = vim.api.nvim_create_augroup("CleanDashboard", {})

		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "AlphaReady",
			callback = function()
				vim.opt.showcmd = false
				vim.opt.ruler = false
			end,
		})

		vim.api.nvim_create_autocmd("BufUnload", {
			group = group,
			pattern = "<buffer>",
			callback = function()
				vim.opt.showcmd = true
				vim.opt.ruler = true
			end,
		})
		dashboard.opts.opts.noautocmd = true
		alpha.setup(dashboard.opts)
	end,
}
