return {
	lsp = {
		clangd = {
			cmd = { "clangd" },
			filetypes = { "c", "cpp", "objc", "objcpp" },
			root_markers = { "compile_commands.json", ".clangd", ".git" },
		},
	},
	conform = {
		formatters_by_ft = {
			c = { "clang_format", lsp_format = "fallback" },
		},
	},
}
