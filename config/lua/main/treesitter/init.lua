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
		},
		move = {
			enable = true,
			set_jumps = true,
		},
		swap = {
			enable = true,
		},
		lsp_interop = {
			enable = true,
			border = "none",
		},
	},
}

local keymaps = {

	--Treesitter selection
	{
		mode = { "n" },
		builder = function(p)
			require("vim.treesitter._select")[p]()
		end,
		desc = function(p)
			return "TS: " .. p
		end,
		keys = {
			["<leader>"] = {
				s = {
					layerdesc = "TS",
					{
						mode = { "n" },
						keys = {
							s = "init_selection",
							i = "node_incremental",
							d = "node_decremental",
							c = "scope_incremental",
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

	--Textobjects selection
	{
		mode = { "x", "o" },
		builder = function(p)
			require("nvim-treesitter-textobjects.select").select_textobject(p, "textobjects")
		end,
		desc = function(p)
			return "TSTO Select: " .. p
		end,
		keys = {
			["aa"] = "@parameter.outer",
			["ia"] = "@parameter.inner",
			["af"] = "@function.outer",
			["if"] = "@parameter.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
		},
	},

	--Textobjects move
	{
		mode = { "n", "x", "o" },
		builder = function(p)
			require("nvim-treesitter-textobjects.move")[p[1]](p[2], p[3])
		end,
		desc = function(p)
			if type(p[2]) ~= "table" then
				return "TSTO Move: " .. p[1] .. p[2]
			else
				local p2 = p[2]
				return "TSTO Move: " .. p[1] .. p2[1] .. p2[2]
			end
		end,
		keys = {
			["]m"] = { "goto_next_start", "@function.outer", "textobjects" },
			["]]"] = { "goto_next_start", "@class.outer", "textobjects" },
			["]o"] = { "goto_next_start", { "@loop.inner", "@loop.outer" }, "textobjects" },
			["]s"] = { "goto_next_start", "@local.scope", "local" },
			["]z"] = { "goto_next_start", "@fold", "folds" },

			["]M"] = { "goto_next_end", "@function.outer", "textobjects" },
			["]["] = { "goto_next_end", "@class.outer", "textobjects" },
			["[m"] = { "goto_previous_start", "@function.outer", "textobjects" },

			["[["] = { "goto_previous_start", "@class.outer", "textobjects" },
			["[M"] = { "goto_previous_end", "@function.outer", "textobjects" },

			["[]"] = { "goto_previous_end", "@class.outer", "textobjects" },
			["]d"] = { "goto_next", "@function.outer", "textobjects" },

			["[d"] = { "goto_previous", "@conditional.outer", "textobjects" },
		},
	},

	--Textobjexts swap
	{
		mode = { "n" },
		builder = function(p)
			return require("nvim-treesitter-textobjects.move")[p[1]](p[2])
		end,
		desc = function(p)
			return "TSTO Swap: " .. p[1] .. p[2]
		end,
		keys = {
			["<leader>ta"] = { "swap_next", "@parameter.inner" },
			["<leader>tt"] = { "swap_previous", "@parameter.outer" },
		},
	},
}

local extraConfig = function()
	require("nvim-ts-autotag").setup()
	require("ts_context_commentstring").setup({
		enable_autocmd = false,
	})

	require("Comment").setup({
		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	})

	--treesitter-based indentation
	vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
