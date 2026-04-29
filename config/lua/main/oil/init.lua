util = require("main.util")
config = {
	default_file_explorer = true,
	columns = {
		"icon",
	},
	view_options = {
		show_hidden = true,
	},
	win_options = {
		wrap = false,
		signcolumn = "number",
		cursorcolumn = true,
	},
	keymaps = {
		["<leader>s?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<leader>sv"] = "actions.select_vsplit",
		["<leader>sh"] = "actions.select_split",
		["<leader>st"] = "actions.select_tab",
		["<leader>sp"] = "actions.preview",
		["<leader>sx"] = "actions.close",
		["<leader>sr"] = "actions.refresh",
		["-"] = "actions.parent",
		["_"] = "actions.open_cwd",
		["`"] = "actions.cd",
		["~"] = "actions.tcd",
		["<leader>sc"] = "actions.change_sort",
		["<leader>se"] = "actions.open_external",
		["<leader>s."] = "actions.toggle_hidden",
		["<leader>sg"] = "actions.toggle_trash",
		["<leader>sd"] = {
			desc = "Toggle file detail view",
			callback = function()
				detail = not detail
				if detail then
					require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
				else
					require("oil").set_columns({ "icon" })
				end
			end,
		},
	},
}

local keymaps = {
	{
		mode = { "n" },
		keys = {
			["<leader>o"] = { "<cmd>Oil<cr>", { desc = "Oil" } },
		},
	},
}

vim.cmd.packadd("oil.nvim")
require("oil").setup(config)
vim.g.loaded_netrwPlugin = 1
util.keymapsForVim(keymaps)
