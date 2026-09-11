local util = require("jnvconf.util")

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

			vim.lsp.config("tinymist", {
				filetypes = { "typst" },
				settings = {
					formatterMode = "typstyle",
					formatterIndentSize = 2,
					semanticTokens = "disable",
				},
			})

			local lsps = {
				"tinymist",
				"lua_ls",
				"bashls",
				"yamlls",
				"jsonls",
				"pyright",
				"scheme_langserver",
				"phpactor",
				"texlab",
				"racket_langserver",
				-- "harper_ls",
			}

			vim.lsp.enable("nixd")
			require("jnvconf.module").forLang(function(lang)
				local lsp = lang.lsp
				if type(lsp) == "table" then
					for server_name, cfg in pairs(lsp) do
						if type(cfg) == "table" and next(cfg) ~= nil then
							vim.lsp.config(server_name, cfg)
						end
						table.insert(lsps, server_name)
					end
				end
			end)
			for _, server_name in ipairs(lsps) do
				vim.lsp.enable(server_name)
			end
		end,
	},
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "markdown", "text", "gitcommit", "norg", "typst" },
-- 	callback = function()
-- 		vim.opt_local.spell = true
-- 		vim.opt_local.spelllang = "en_us"
-- 		vim.opt_local.textwidth = 80
-- 		vim.opt_local.formatoptions:append("t")
-- 	end,
-- })
