local util = require("main.util")
local config = {
	instructions_file = ".avante.md",
	provider = "openai",
	providers = {
		openai = {
			model = "gpt-4o",
		},
		-- openai_latest = {
		-- 	model = "gpt-5.4",
		-- 	disable_tools = true,
		-- 	extra_request_body = {
		-- 		-- temperature = 1,
		-- 		max_completion_tokens = 4093,
		-- 	},
		-- },
	},
	selection = {
		enabled = true,
		hint_display = "none",
	},
	input = {
		provider = "snacks",
	},
	windows = {
		ask = { border = "single" },
		edit = { border = "single" },
		sidebar_header = { rounded = false },
	},
	mappings = {
		diff = {
			ours = "co",
			theirs = "ct",
			all_theirs = "ca",
			both = "cb",
			cursor = "cc",
			next = "]x",
			prev = "[x",
		},
		suggestion = {
			accept = "<M-l>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
		jump = {
			next = "]]",
			prev = "[[",
		},
		submit = {
			normal = "<CR>",
			insert = "<C-s>",
		},
		ask = "<leader>aa",
		edit = "<leader>ae",
		refresh = "<leader>ar",
		focus = "<leader>af",
		toggle = {
			default = "<leader>at",
			debug = "<leader>ad",
			hint = "<leader>ah",
			suggestion = "<leader>as",
			repomap = "<leader>aR",
		},
		sidebar = {
			apply_all = "A",
			apply_cursor = "a",
			retry_user_request = "r",
			edit_user_request = "e",
			switch_windows = "<Tab>",
			reverse_switch_windows = "<S-Tab>",
			remove_file = "d",
			add_file = "@",
			close = { "<Esc>", "q" },
			close_from_input = nil,
		},
		files = {
			add_current = "<leader>ac",
		},
		select_model = "<leader>a?",
	},
}

local keymaps = {
	{
		mode = { "n", "v" },
		builder = function(p)
			require("avante.api")[p]()
		end,
		desc = function(p)
			return "Avante: " .. p
		end,
		keys = {
			["<leader>"] = {
				a = {
					layerdesc = "Avante",
					a = "ask",
					e = "edit",
					t = "toggle",
					r = "refresh",
				},
			},
		},
	},
}

require("lz.n").load({
	{
		"avante.nvim",
		keys = util.keymapsForLzn(keymaps),
		cmd = {
			"AvanteAsk",
			"AvanteEdit",
			"AvanteBuild",
			"AvanteClear",
			"AvanteToggle",
			"AvanteRefresh",
			"AvanteSwitchProvider",
		},
		load = function(name)
			util.addPacks(name, {
				"nui.nvim",
			})
		end,
		after = function()
			require("avante").setup(config)
		end,
	},
})

--[[
TODO:prompt snippet
  from what is provided in this code snippet:
    <here> <- inserted from visual mode
  what does this mean:
    <cursor insert>
]]
