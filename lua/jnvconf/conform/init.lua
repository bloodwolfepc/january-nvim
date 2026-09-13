local module = require("jnvconf.module")

local config = {
	format_on_save = function(bufnr)
		local disable_filetypes = { c = true, cpp = true }
		if disable_filetypes[vim.bo[bufnr].filetype] then
			return nil
		end

		return {
			timeout_ms = 500,
			lsp_format = "fallback",
		}
	end,
	formatters = {
		lilypond = {
			command = "ly",
			args = { "reformat" },
		},
	},
	formatters_by_ft = {
		rust = { "rustfmt", lsp_format = "fallback" },
		lua = { "stylua", lsp_format = "fallback" },
		typst = { "typstyle" },
		lilypond = { "lilypond" },
		kdl = { "kdlfmt" },
	},
}

require("lz.n").load({
	{
		"conform.nvim",
		event = "DeferredUIEnter",
		after = function()
			module.forModules(function(m)
				if type(m) ~= "table" then
					return
				end

				local conform = m.conform
				if type(conform) ~= "table" then
					return
				end

				if type(conform.config) == "table" then
					config = vim.tbl_deep_extend("force", config, conform.config)
				end
			end, { submodules = { "langs", "codecompanion" } })

			require("conform").setup(config)
		end,
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
