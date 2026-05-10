local util = require("main.util")

require("lz.n").load({
	{
		"nvim-lspconfig",
		priority = 51,
		event = "DeferredUIEnter",
		load = function(name)
			util.addPacks(name, {
				"lazydev.nvim",
			})
		end,
		after = function()
			require("lazydev").setup()
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("nixd")
			vim.lsp.enable("bashls")
			vim.lsp.enable("yamlls")
			vim.lsp.enable("jsonls")
			vim.lsp.enable("clangd")
			vim.lsp.enable("pyright")
			vim.lsp.enable("scheme_langserver")
			vim.lsp.enable("phpactor")
		end,
	},
})
