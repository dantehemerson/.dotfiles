return {
	{
		"goolord/alpha-nvim",
		enabled = true,
		event = "VimEnter",
		init = false,
		config = function()
			local dashboard = require("alpha.themes.dashboard")
			local logo = [[
        ⠀⠀⠀⢀⣀⣤⣤⣤⣤⣄⡀⠀⠀⠀⠀
        ⠀⢀⣤⣾⣿⣾⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀
        ⢠⣾⣿⢛⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀
        ⣾⣯⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧
        ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
        ⣿⡿⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠻⢿⡵
        ⢸⡇⠀⠀⠉⠛⠛⣿⣿⠛⠛⠉⠀⠀⣿⡇
        ⢸⣿⣀⠀⢀⣠⣴⡇⠹⣦⣄⡀⠀⣠⣿⡇
        ⠈⠻⠿⠿⣟⣿⣿⣦⣤⣼⣿⣿⠿⠿⠟⠀
        ⠀⠀⠀⠀⠸⡿⣿⣿⢿⡿⢿⠇⠀⠀⠀⠀
        ⠀⠀⠀⠀⠀⠀⠈⠁⠈⠁⠀⠀⠀⠀⠀⠀
                       _
 _ __   ___  _____   _(_)_ __ ___  
| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ 
| | | |  __/ (_) \ V /| | | | | | |
|_| |_|\___|\___/ \_/ |_|_| |_| |_|
    ]]
			dashboard.section.header.val = vim.split(logo, "\n")

			dashboard.section.buttons.val = {
				dashboard.button("f", " " .. " Find file", "<cmd>Telescope find_files<cr>"),
				dashboard.button("n", " " .. " New file", [[<cmd> ene <BAR> startinsert <cr>]]),
				dashboard.button("r", " " .. " Recent files", [[<cmd> lua LazyVim.pick("oldfiles")() <cr>]]),
				dashboard.button("g", " " .. " Find text", [[<cmd> lua LazyVim.pick("live_grep")() <cr>]]),
				dashboard.button("c", " " .. " Config", "<cmd> lua LazyVim.pick.config_files()() <cr>"),
				dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
				dashboard.button("x", " " .. " Lazy Extras", "<cmd> LazyExtras <cr>"),
				dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
				dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
			}
			require("alpha").setup(dashboard.config)

			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = math.floor(stats.startuptime) .. " ms"
					dashboard.section.footer.val = "  Loaded "
						.. stats.loaded
						.. "/"
						.. stats.count
						.. " plugins in "
						.. ms
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
}
