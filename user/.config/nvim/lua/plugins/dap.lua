return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- UI and visual enhancements
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",

		-- Integration with Mason for automatic DAP server installations
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},

	keys = {
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<leader>do",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<leader>dO",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Conditional Breakpoint",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "Debug: Terminate",
		},
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "Debug: Toggle UI",
		},
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Setup Virtual Text & UI
		require("nvim-dap-virtual-text").setup()
		dapui.setup()

		-- Automatically open/close DAP UI when session starts/ends
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Mason DAP integration
		require("mason-nvim-dap").setup({
			-- Automatic installation of DAP servers via Mason
			ensure_installed = {
				"js", -- js-debug-adapter (Node/TS)
			},
			automatic_installation = true,
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		})

		dap.adapters["pwa-node"] = {
			type = "server",
			host = "127.0.0.1",
			port = "${port}",
			executable = {
				command = "node",
				args = {
					-- NOTE that we don't need to hardcode the path, but can instead use the location from the Mason-installed version via `:MasonInstall js-debug-adapter`
					vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					-- NOTE that there's an issue with nvim-dap calling this if you DO NOT specify a port and the host as `127.0.0.1`
					"${port}",
					"127.0.0.1",
				},
			},
		}

		local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

		for _, language in ipairs(js_based_languages) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to process",
					processId = function()
						-- This filters the list to ONLY show processes containing "node"
						return require("dap.utils").pick_process({
							filter = function(process)
								local name = process.name

								if not name:match("/node") then
									return false
								end

								return not (
									name:find("typescript-language-server", 1, true)
									or name:find("tsserver.js", 1, true)
									or name:find("typingsInstaller.js", 1, true)
								)
							end,
						})
					end,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					-- This ensures Neovim finds the actual source files, not the compiled output
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
				},
			}
		end

		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })
		vim.fn.sign_define("DapLogPoint", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })
	end,
}
