local util = require("jnvconf.util")
local module = require("jnvconf.module")

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

			local lsps = {}

			module.forModules(function(m)
				if type(m) ~= "table" then
					return
				end

				local lsp = m.lsp
				if type(lsp) ~= "table" then
					return
				end

				for server_name, cfg in pairs(lsp) do
					if type(cfg) == "table" then
						vim.lsp.config(server_name, cfg)
					end
					lsps[#lsps + 1] = server_name
				end
			end, { submodules = { "langs" } })

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
