local util = require("main.util")
local config = {
	defaults = {
		border = false,
		borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
		layout_strategy = "horizontal",
		sorting_strategy = "ascending",
		path_display = { "filename_first" },
		layout_config = {
			horizontal = {
				prompt_position = "top",
				width = { padding = 0 },
				height = { padding = 0 },
				preview_width = 0.5,
			},
		},
		file_ignore_patterns = {
			"%.lock",
		},
	},
	fakeconfig = {},
	extensions = {
		fzf = {},
	},
}

local keymaps = {
	{
		mode = { "n" },
		builder = function(p)
			require("telescope.builtin")[p]()
		end,
		desc = function(p)
			return "Telescope: " .. p
		end,
		keys = {
			["<leader>"] = {
				["<leader>"] = "live_grep",
				f = {
					layerdesc = "TEL",
					f = "find_files",
					k = "keymaps",
					o = "oldfiles",
					r = "resume",
					d = "diagnosics",
					s = "grep_string",
					c = "commands",
					t = "tags",
					h = "help_tags",
					m = "marks",
					q = "quickfix",
					j = "jumplist",
					b = "buffers",
					F = "current_buffer_fuzzy_find",
					G = "spell_suggest",
					Q = "quickfixhistory",
					C = "command_history",
					S = "search_history",
					M = "man_pages",
					B = "builtin",
					e = "symbols",
					g = {
						c = "git_commits",
						b = "git_bcommits",
						v = "git_bcommits_range",
						s = "git_status",
						S = "git_stash",
						B = "git_branches",
					},
				},
			},
		},
	},
}

local extraConf = function()
	for _, v in ipairs({
		"fzf",
		"zoxide",
		"telescope-manix",
		"emoji",
		"gh",
		"conflicts",
		"coc",
		"dap",
		"undo",
		"manix",
	}) do
		pcall(require("telescope").load_extension, v)
	end

	--fullscreen autocmd
	local temp_showtabline
	local temp_laststatus
	function _G.global_telescope_find_pre()
		temp_showtabline = vim.o.showtabline
		temp_laststatus = vim.o.laststatus
		vim.o.showtabline = 0
		vim.o.laststatus = 0
	end
	function _G.global_telescope_leave_prompt()
		vim.o.laststatus = temp_laststatus
		vim.o.showtabline = temp_showtabline
	end
	vim.cmd([[
    augroup MyAutocmds
      autocmd!
      autocmd User TelescopeFindPre lua global_telescope_find_pre()
      autocmd FileType TelescopePrompt autocmd BufLeave <buffer> lua global_telescope_leave_prompt()
    augroup END
  ]])
end

require("lz.n").load({
	{
		"telescope.nvim",
		cmd = "Telescope",
		keys = util.keymapsForLzn(keymaps),
		load = function(name)
			util.addPacks(name, {
				"telescope-fzf-native.nvim",
				"telescope-ui-select.nvim",
				"telescope-symbols.nvim",
				"telescope-emoji.nvim",
				"telescope-github.nvim",
				"telescope-git-conflicts.nvim",
				"telescope-coc.nvim",
				"telescope-dap.nvim",
				"telescope-undo.nvim",
				"telescope-zoxide",
				"telescope-manix",
			})
		end,
		after = function()
			extraConf()
			require("telescope").setup(config)
		end,
	},
})
