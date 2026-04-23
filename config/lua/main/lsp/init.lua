local catUtils = require("nixCatsUtils")
vim.lsp.set_log_level("debug")

require("lze").load({
	{
		"nvim-lspconfig",
		for_cat = "lsp",
		on_require = { "lspconfig" },
		lsp = function(plugin)
			require("lspconfig")[plugin.name].setup(vim.tbl_extend("force", {
				capabilities = require("config.lsp.caps-on_attach").get_capabilities(plugin.name),
				on_attach = require("config.lsp.caps-on_attach").on_attach,
			}, plugin.lsp or {}))
		end,
	},
	{
		"lazydev.nvim",
		for_cat = "lua",
		cmd = { "LazyDev" },
		ft = "lua",
		after = function(_)
			require("lazydev").setup({
				library = {
					{ words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. "/lua" },
				},
			})
		end,
	},
	{
		"lua_ls",
		enabled = nixCats("lua") or false,
		lsp = {
			filetypes = { "lua" },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					formatters = {
						ignoreComments = true,
					},
					signatureHelp = { enabled = true },
					diagnostics = {
						globals = { "nixCats", "vim" },
						disable = { "missing-fields" },
					},
					telemetry = { enabled = false },
				},
			},
		},
	},
	{
		"nixd",
		enabled = nixCats("nix") or false,
		lsp = {
			filetypes = { "nix" },
			settings = {
				nixd = {
					nixpkgs = {
						expr = [[import (builtins.getFlake "]] .. nixCats.extra("nixdExtras.nixpkgs") .. [[") { }   ]],
					},
					formatting = {
						command = { "nixfmt" },
					},
					options = {
						nixos = {
							expr = nixCats.extra("nixdExtras.nixos_options"),
						},
						["home-manager"] = {
							expr = nixCats.extra("nixdExtras.home_manager_options"),
						},
					},
					diagnostic = {
						suppress = {
							"sema-escaping-with",
						},
					},
				},
			},
		},
	},
	-- {
	--   "null-ls.nvim",
	--   enabled = nixCats("lsp") or false,
	--   lazy = false,
	--   after = function()
	--     local null_ls = require("null-ls")
	--     null_ls.setup({
	--       sources = { }
	--     })
	--   end,
	-- },
	{
		"bashls",
		enabled = nixCats("bash") or false,
		for_cat = "bash",
		lsp = {
			filetypes = { "sh", "bash" },
		},
	},
	{
		"yamlls",
		enabled = nixCats("yaml") or false,
		lsp = {
			filetypes = { "yaml", "yml" },
		},
	},
	{
		"jsonls",
		enabled = nixCats("json") or false,
		lsp = {
			filetypes = { "json" },
		},
	},
	{
		"clangd",
		enabled = nixCats("c") or false,
		lsp = {
			filetypes = { "c", "cpp" },
		},
	},
	{
		"pyright",
		enabled = nixCats("python") or false,
		lsp = {
			filetypes = { "python", "py" },
		},
	},

	-- https://github.com/ufo5260987423/scheme-langserver/issues/62
	-- {
	--   "scheme_langserver",
	--   enabled = nixCats("scheme") or false,
	--   lsp = {
	--     filetypes = { "scheme", "scm", "ss" },
	--   },
	-- },
})
