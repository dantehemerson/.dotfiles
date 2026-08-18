return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			keymap = {
				preset = "default",

				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<CR>"] = { "accept", "fallback" },

				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = {
					auto_show = true,
				},
			},

			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
				},
			},

			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
		},
	},
}
