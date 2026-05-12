local util = require("main.util")
local config = {
	default_keymappings_enabled = false,
}
local end_mappings = {
	["u"] = "to_upper_case",
	["l"] = "to_lower_case",
	["s"] = "to_snake_case",
	["d"] = "to_dash_case",
	["n"] = "to_constant_case",
	["o"] = "to_dot_case",
	[","] = "to_comma_case",
	["a"] = "to_phrase_case",
	["c"] = "to_camel_case",
	["p"] = "to_pascal_case",
	["t"] = "to_title_case",
	["f"] = "to_path_case",
}

local keymaps = {
	{
		mode = { "n", "v", "o" },
		builder = function(p)
			require("textcase").current_word(p)
		end,
		desc = function(p)
			return "CASE: current_word " .. p
		end,
		keys = {
			["ga"] = end_mappings,
		},
	},
	{
		mode = { "n", "v" },
		builder = function(p)
			require("textcase").lsp_rename(p)
		end,
		desc = function(p)
			return "CASE: lsp_rename " .. p
		end,
		keys = {
			["gA"] = end_mappings,
		},
	},
	{
		mode = { "n", "v" },
		builder = function(p)
			require("textcase").operator(p)
		end,
		desc = function(p)
			return "CASE: operator " .. p
		end,
		keys = {
			["ge"] = end_mappings,
		},
	},
	{
		mode = { "n", "v" },
		keys = {
			["ga."] = { "<cmd>TextCaseOpenTelescope<cr>", { desc = "CASE: Telescope" } },
		},
	},
	{
		mode = { "n", "v" },
		keys = {
			["gaA"] = { "<cmd>TextCaseOpenTelescopeQuickChange<cr>", { desc = "CASE: Telescope Chnage" } },
			["gaI"] = { "<cmd>TextCaseOpenTelescopeLSPChange<cr>", { desc = "CASE: LSP Change" } },
		},
	},
}

require("lz.n").load({
	{
		"text-case.nvim",
		-- cmd = {
		-- 	"Subs",
		-- 	"TextCaseOpenTelescope",
		-- 	"TextCaseOpenTelescopeQuickChange",
		-- 	"TextCaseOpenTelescopeLSPChange",
		-- 	"TextCaseStartReplacingCommand",
		-- },
		event = "DeferredUIEnter",
		keys = util.keymapsForLzn(keymaps),
		after = function()
			require("textcase").setup(config)
			require("telescope").load_extension("textcase")
		end,
	},
})
