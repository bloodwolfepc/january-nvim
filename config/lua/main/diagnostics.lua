local util = require("main.util")
local diagnostic = vim.diagnostic

local keymaps = {
	{
		mode = { "n" },
		builder = function(p)
			diagnostic[p]()
		end,
		desc = function(p)
			return "DIAGNOSTIC: " .. p
		end,

		keys = {
			["[d"] = "goto_prev",
			["]d"] = "goto_next",
			["<leader>e"] = "open_float",
			["<leader>q"] = "setloclist",
		},
	},
}

diagnostic.config({
	virtual_text = false,
	virtual_lines = true,
})
util.keymapsForVim(keymaps)
