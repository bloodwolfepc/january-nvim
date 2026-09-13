local util = require("jnvconf.util")

require("lz.n").load({
	{
		"nvim-lint",
		event = "DeferredUIEnter",
		after = function()
			local lint = require("lint")
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
})
