--[[
TODO:
https://github.com/dharmx/telescope-media.nvim
https://github.com/nvim-telescope/telescope-bibtex.nvim
https://github.com/ahmedkhalf/project.nvim
function which greps though and finds, places you into only directories (not single files)
starting from src and from home, useful for oil
]]
local kb = function()
	local mapKeys = require("utils.mapKeys")

	local function cmd(cmd1, m)
		return {
			function()
				local telescope = function()
					if m == 1 then
						return require("config.telescope.module")
					elseif type(m) == "string" then
						return require("telescope").extensions[m]
					else
						return require("telescope.builtin")
					end
				end
				return (telescope)()[cmd1]()
			end,
			"" .. cmd1,
		}
	end

	local kb1 = {
		n = {
			["<leader>"] = {
				["<leader>"] = cmd("live_grep"),
				f = {
					f = cmd("find_files"),
					-- f = {require('telescope.builtin').find_files(), find_files}
					k = cmd("keymaps"),
					o = cmd("oldfiles"),
					r = cmd("resume"),
					d = cmd("diagnosics"),
					s = cmd("grep_string"),
					c = cmd("commands"),
					t = cmd("tags"),
					h = cmd("help_tags"),
					m = cmd("marks"),
					q = cmd("quickfix"),
					j = cmd("jumplist"),
					b = cmd("buffers"),
					F = cmd("current_buffer_fuzzy_find"),
					G = cmd("spell_suggest"),
					Q = cmd("quickfixhistory"),
					C = cmd("command_history"),
					S = cmd("search_history"),
					M = cmd("man_pages"),
					B = cmd("builtin"),
					e = cmd("symbols"),
					g = {
						c = cmd("git_commits"),
						b = cmd("git_bcommits"),
						v = cmd("git_bcommits_range"),
						s = cmd("git_status"),
						S = cmd("git_stash"),
						B = cmd("git_branches"),
					},
					["<leader>"] = {
						["<leader>"] = cmd("grep_notes", 1),
						n = cmd("grep_notes_all", 1),
						s = cmd("find_notes", 1),
						h = cmd("find_home_files", 1),
						z = cmd("list", "zoxide"),
						M = cmd("manix", "manix"),
						e = cmd("emoji", "emoji"),
						u = cmd("undo", "undo"),
						g = {
							i = cmd("issues", "gh"),
							p = cmd("pull_request", "gh"),
							g = cmd("gist", "gh"),
							r = cmd("run", "gh"),
							c = cmd("conflicts", "conflicts"),
						},
						c = {
							c = cmd("commands", "coc"),
							l = cmd("links", "coc"),
							m = cmd("mru", "coc"),
							r = cmd("references", "coc"),
						},
						d = {
							c = cmd("commands", "dap"),
							u = cmd("configurations", "dap"),
							b = cmd("list_breakpoints", "dap"),
							v = cmd("variables", "dap"),
							f = cmd("frames", "dap"),
						},
					},
				},
			},
		},
	}
	return mapKeys.lze(kb1)
end

require("lze").load({
	{
		"telescope.nvim",
		for_cat = { cat = "telescope", default = false },
		cmd = { "Telescope" },
		on_require = { "telescope" },
		keys = (kb)(),
		load = function(name)
			require("utils.extraUtils").addPacks(name, {
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
			}) do
				pcall(require("telescope").load_extension, v)
			end

			if nixCats("nix") then
				pcall(require("telescope").load_extension, "manix")
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

			require("telescope").setup({
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
				extensions = {
					fzf = {},
				},
			})
		end,
	},
})
