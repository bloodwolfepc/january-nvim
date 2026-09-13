return {
	lsp = {
		lua_ls = {},
	},
	conform = {
		config = {
			formatters_by_ft = {
				lua = { "stylua", lsp_format = "fallback" },
			},
		},
	},
}
