return {
	lsp = {
		clangd = {},
	},
	conform = {
		formatters_by_ft = {
			c = { "clang_format", lsp_format = "fallback" },
		},
	},
}
