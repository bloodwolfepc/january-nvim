local util = require("main.util")

local config = {
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_slection = "<leader>ss", --start selection
			node_incremental = "<leader>si", --selection increment
			scope_incremental = "<leader>sc", --scope
			node_decremental = "<leeader>sd", --selection decrement
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			selection_modes = {
				["@parameter.outer"] = "v",
				["@function.outer"] = "V",
				["@class.outer"] = "<c-v>",
			},
			keymaps = {
				["aa"] = { query = "@parameter.outer", desc = "@parameter.outer" },
				["ia"] = { query = "@parameter.inner", desc = "@parameter.inner" },
				["af"] = { query = "@function.outer", desc = "@function.outer" },
				["if"] = { query = "@function.inner", desc = "@function.inner" },
				["ac"] = { query = "@class.outer", desc = "@class.outer" },
				["ic"] = { query = "@class.inner", desc = "@class.inner" },
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = { query = "@function.outer", desc = "@function.outer" },
				["]]"] = { query = "@class.outer", desc = "@class.outer" },
			},
			goto_next_end = {
				["]M"] = { query = "@function.outer", desc = "@function.outer" },
				["]["] = { query = "@class.outer", desc = "@class.outer" },
			},
			goto_previous_start = {
				["[m"] = { query = "@function.outer", desc = "@function.outer" },
				["[["] = { query = "@class.outer", desc = "@class.outer" },
			},
			goto_previous_end = {
				["[M"] = { query = "@function.outer", desc = "@function.outer" },
				["[]"] = { query = "@class.outer", desc = "@class.outer" },
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>ta"] = { query = "@parameter.inner", desc = "@parameter.inner" },
			},
			swap_previous = {
				["<leader>tt"] = { query = "@parameter.inner", desc = "@parameter.inner" },
			},
		},
		lsp_interop = {
			enable = true,
			border = "none",
			floating_preview_opts = {},
			peek_definition_code = {
				["<leader>df"] = { query = "@function.outer", desc = "@function.outer" },
				["<leader>dF"] = { query = "@class.outer", desc = "@class.outer" },
			},
		},
	},
}

local keymaps = {
	{
		mode = { "n" },
		builder = {
			passthough = function(p)
				require("nvim-treesitter.incremental_selection")()[p]()
			end,
		},
		keys = {
			["<leader>"] = {
				l = {
					{
						mode = { "n" },
						keys = {
							s = "init_selection",
						},
					},
					{
						mode = { "v" },
						keys = {
							i = "node_incremental",
							d = "node_decremental",
							c = "scope_incremental",
						},
					},
				},
			},
		},
	},
	{
		mode = { "n" },
		builder = {
			passthough = function(p)
				require("nvim-treesitter-textobjects.select").select_textobject(p, "textobjects")
			end,
		},
		keys = {},
	},
}

local extraConfig = function()
	-- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
	-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
	-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
	-- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
	-- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
	-- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
	-- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
	require("nvim-ts-autotag").setup()
	require("ts_context_commentstring").setup({
		enable_autocmd = false,
	})
	require("Comment").setup({
		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	})
end

require("lz.n").load({
	{
		"nvim-treesitter",
		event = "DeferredUIEnter",
		load = function(name)
			util.addPacks(name, {
				"nvim-treesitter-textobjects",
				"nvim-ts-autotag",
				"nvim-ts-context-commentstring",
				"comment.nvim",
			})
		end,
		after = function()
			require("nvim-treesitter").setup(config)
			extraConfig()
			util.keymapsForVim(keymaps)
		end,
	},
})
