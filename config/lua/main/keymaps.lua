local util = require("main.util")

local keymaps = {
	{
		mode = { "n" },
		keys = {
			["<C-h>"] = { "<C-w>h", { desc = "Move focus left" } },
			["<C-j>"] = { "<C-w>j", { desc = "Move focus down" } },
			["<C-k>"] = { "<C-w>k", { desc = "Move focus up" } },
			["<C-l>"] = { "<C-w>l", { desc = "Move focus right" } },
			["t<Esc><Esc>"] = { "<C-\\><C-n>", { desc = "Exit terminal mode" } },
		},
	},
}
util.keymapsForVim(keymaps)
