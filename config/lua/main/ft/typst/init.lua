local util = require("main.util")
local config = {
	open_cmd = "firefox %s",
	invert_colors = "always",
	folow_cursor = true,
	-- dependencies_bin = { -- FIXES: https://github.com/chomosuke/typst-preview.nvim/issues/136
	-- 	tinymist = "tinymist",
	-- 	websocat = "websocat",
	-- },
}
local keymaps = {
	{
		mode = { "n" },
		builder = function(p)
			return vim.cmd("TypstPreview" .. p)
		end,
		desc = function(p)
			if p == "" then
				p = "Preview"
			end
			return "TYPST: " .. p
		end,
		keys = {
			["<leader>"] = {
				["s"] = {
					["u"] = "Update",
					["p"] = "",
					["s"] = "Stop",
					["t"] = "Toggle",
					["cf"] = "FollowCuror",
					["cn"] = "NoFollowCursor",
					["ct"] = "FollowCursorToggle",
					["cs"] = "SyncCursor",
				},
			},
		},
	},
}

require("lz.n").load({
	{
		"typst-preview.nvim",
		-- ft = { "typ", "typst" },
		event = "DeferredUIEnter",
		after = function()
			require("typst-preview").setup(config)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "typ", "typst" },
				callback = function()
					util.keymapsForVim(keymaps) -- TOOD: If buffer in not focused, ummap
				end,
			})
		end,
	},
})
