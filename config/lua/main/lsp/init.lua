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

			vim.lsp.config("harper_ls", {
				settings = {
					["harper-ls"] = {
						filetypes = {
							"asciidoc",
							"c",
							"cpp",
							"cs",
							"gitcommit",
							"go",
							"html",
							"java",
							"javascript",
							"lua",
							"markdown",
							"nix",
							"python",
							"ruby",
							"rust",
							"swift",
							"toml",
							"typescript",
							"typescriptreact",
							"haskell",
							"cmake",
							"typst",
							"php",
							"dart",
							"clojure",
							"sh",
						},
					},
				},
			})

			vim.lsp.enable("lua_ls")
			vim.lsp.enable("nixd")
			vim.lsp.enable("bashls")
			vim.lsp.enable("yamlls")
			vim.lsp.enable("jsonls")
			vim.lsp.enable("clangd")
			vim.lsp.enable("pyright")
			vim.lsp.enable("scheme_langserver")
			vim.lsp.enable("phpactor")
			vim.lsp.enable("texlab")

			--vim.lsp.enable("harper_ls")

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "markdown", "text", "gitcommit", "norg" },
				callback = function()
					vim.opt_local.spell = true
					vim.opt_local.spelllang = "en_us"
					-- vim.opt_local.spelloptions = { "camel" }
					-- vim.opt_local.spellsugges = "best,9"
					-- vim.opt_local.spellcapcheck =
				end,
			})
		end,
	},
})
