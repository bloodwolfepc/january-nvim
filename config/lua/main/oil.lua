local util = require("main.util")
local config = {
	default_file_explorer = true,
	win_options = {
		wrap = false,
		signcolumn = "number",
		cursorcolumn = true,
	},
	columns = {
		"icon",
	},
	view_options = {
		show_hidden = true,
	},
	watch_for_changes = true,
	use_default_keymaps = false,
}

local keymaps = {
	{
		mode = { "n" },
		builder = function(p)
			require("oil.actions")[p].callback()
		end,
		opts = { buffer = 0 },
		desc = function(p)
			return "OIL: " .. p
		end,
		keys = {
			["<CR>"] = "select",
			["-"] = "parent",
			["_"] = "open_cwd",
			["`"] = "cd",
			["~"] = "tcd",
			["<leader>O"] = {
				["?"] = "show_help",
				["v"] = "select_vsplit",
				["h"] = "select_split",
				["t"] = "select_tab",
				["p"] = "preview",
				["x"] = "close",
				["r"] = "refresh",
				["c"] = "change_sort",
				["e"] = "open_external",
				["."] = "toggle_hidden",
				["g"] = "toggle_trash",
			},
		},
	},
}

vim.cmd.packadd("oil.nvim")
require("oil").setup(config)
vim.g.loaded_netrwPlugin = 1

util.keymapsForVim({
	{
		mode = { "n" },
		keys = {
			["<leader>o"] = {
				function()
					require("oil.actions").open_cwd.callback()
				end,
				{ desc = "Oil" },
			},
		},
	},
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "oil://*" },
	callback = function()
		util.keymapsForVim(keymaps)
	end,
})
