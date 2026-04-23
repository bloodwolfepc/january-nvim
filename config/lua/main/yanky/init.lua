local util = require("main.util")
local config = {
	highlight = {
		timer = 300,
	},
}
local keymaps = {
	{
		mode = { "n", "x" },
		builder = {
			descmode = "inherit",
		},
		keys = {
			-- yy = function()
			-- 	vim.api.nvim_commnd("normal! yy")
			-- end,
			yy = "<cmd>yank<cr>",
			p = "<Plug>(YankyPutAfter)",
			P = "<Plug>(YankyPutAfter)",
			g = {
				p = "<Plug>(YankyGPutAfter)",
				P = "<Plug>(YankyGPutAfter)",
			},
		},
	},
	{
		mode = { "n" },
		builder = {
			descmode = "inherit",
		},
		keys = {
			["<c-p>"] = "<Plug>(YankyPreviousEntry)",
			["<c-n>"] = "<Plug>(YankyNextEntry)",
			["]p"] = "<Plug>(YankyPutIndentAfterLinewise)",
			["[p"] = "<Plug>(YankyPutIndentBeforeLinewise)",
			["]P"] = "<Plug>(YankyPutIndentAfterLinewise)",
			["[P"] = "<Plug>(YankyPutIndentBeforeLinewise)",
			[">p"] = "<Plug>(YankyPutIndentAfterShiftRight)",
			["<p"] = "<Plug>(YankyPutIndentAfterShiftLeft)",
			[">P"] = "<Plug>(YankyPutIndentBeforeShiftRight)",
			["<P"] = "<Plug>(YankyPutIndentBeforeShiftLeft)",
			["=p"] = "<Plug>(YankyPutAfterFilter)",
			["=P"] = "<Plug>(YankyPutBeforeFilter)",
		},
	},
}

require("lz.n").load({
	{
		"yanky.nvim",
		cmd = { "YankyRingHistory", "YankyClearHistory" },
		keys = util.keymapsForLzn(keymaps),
		after = function()
			require("yanky").setup(config)
		end,
	},
})
