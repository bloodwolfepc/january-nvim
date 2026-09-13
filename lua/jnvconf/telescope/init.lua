local util = require("jnvconf.util")
local module = require("jnvconf.module")

local keymaps = {
	{
		mode = { "n" },
		builder = function(p)
			require("telescope.builtin")[p]()
		end,
		desc = function(p)
			return "TEL: " .. p
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
						layerdesc = "GIT",
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

local function extraConf()
	local extensions = {
		"fzf",
		"zoxide",
		"emoji",
		"gh",
		"conflicts",
		"coc",
		"dap",
		"undo",
	}

	module.forModules(function(m)
		if type(m) ~= "table" then
			return
		end

		local telescope = m.telescope
		if type(telescope) ~= "table" then
			return
		end

		if type(telescope.load_extension) == "table" then
			vim.list_extend(extensions, telescope.load_extension)
		end

		if type(telescope.config) == "table" then
			config = vim.tbl_deep_extend("force", config, telescope.config)
		end
	end)

	for _, v in ipairs(extensions) do
		pcall(require("telescope").load_extension, v)
	end

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
		event = "DeferredUIEnter",
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
		priority = 52,
	},
})
