local util = require("main.util")
local config = {
	load = {
		["core.defaults"] = {},
		--["core.integrations.image"] = {},
		["core.latex.renderer"] = {},
		["core.dirman"] = {
			config = {
				workspaces = {
					notebook = "~/notebook",
				},
				default_workspace = "notebook",
			},
		},
		["core.keybinds"] = {
			config = {
				default_keybinds = false,
			},
		},
		["core.concealer"] = {
			config = {
				--icon_preset = "diamond",
			},
		},
		["external.interim-ls"] = {
			config = {
				completion_provider = {
					enable = true,
					documentation = true,
					categories = false,
				},
			},
		},
		["core.completion"] = {
			config = { engine = { module_name = "external.lsp-completion" } },
		},
		["core.integrations.telescope"] = {
			config = {
				insert_file_link = {
					show_title_preview = true,
				},
			},
		},
	},
}

local global_keymaps = {
	--Telescope
	{
		mode = { "n" },
		builder = function(p)
			return vim.cmd("Telescope neorg " .. p)
		end,
		desc = function(p)
			return "NORG TEL: " .. p
		end,
		keys = {
			["<leader>nf"] = {
				layerdesc = "TEL",
				["ap"] = "find_aof_project_tasks",
				["at"] = "find_aof_tasks",
				["b"] = "find_backlinks",
				["t"] = "find_context_tasks",
				["hb"] = "find_header_backlinks",
				["l"] = "find_linnkable",
				["f"] = "find_norg_files",
				["p"] = "find_project_tasks",
				["F"] = "insert_file_link",
				["i"] = "insert_link",
				["h"] = "search_headings",
				["w"] = "switch_workspace",
			},
		},
	},
	{
		mode = { "n" },
		builder = function(p)
			return vim.cmd(':execute "normal \\<Plug>(neorg.' .. p .. ')"')
		end,
		opts = { buffer = true },
		desc = function(p)
			return "NORG: " .. p
		end,
		keys = {
			["<leader>n"] = {
				layerdesc = "NORG",
				n = "dirman.new-note",
			},
		},
	},
	{
		mode = { "n" },
		keys = {
			["<leader>nt"] = { "<cmd>Neorg toc<cr>", { desc = "NORG: toc" } },
			["<leader>no"] = { "<cmd>Neorg index<cr>", { desc = "NORG: index" } },
			["<leader>nj"] = { "<cmd>Neorg jornal<cr>", { desc = "NORG: journal" } },
			["<leader>nr"] = { "<cmd>Neorg return<cr>", { desc = "NORG: return" } },
		},
	},
}

local keymaps = {
	{
		builder = function(p)
			return vim.cmd(':execute "normal \\<Plug>(neorg.' .. p .. ')"')
		end,
		opts = { buffer = true },
		desc = function(p)
			return "NORG: " .. p
		end,
		keys = {
			["<localleader>"] = {
				{
					mode = { "i" },
					keys = {
						["<c-d>"] = "promo.demote",
						["<c-t>"] = "promo.promote",
						["<c-cr"] = "promo.next-interation",
						["<m-d>"] = "promo.tempus.insert-date.insert-mode",
					},
				},
				{
					mode = { "n" },
					keys = {
						["<,"] = "promo.demote",
						["<<"] = "promo.demote.nested",
						["."] = "promo.promote",
						[">>"] = "promo.promote.nested",
						["<cr>"] = "esupports.hop.hop-link",
						["<m-cr>"] = "esupports.hop.hop-link.vsplit",
						["<m-t>"] = "esupports.hop.hop-link.tab-drop",
						["<c-space>"] = "qol.todo-items.todo.task-cycle",
						["<localleader>c"] = {
							layerdesc = "CODE",
							m = "looking-glass.magnify",
						},
						["<localleader>i"] = {
							layerdesc = "INS",
							d = "tempus.insert-date",
						},
						["<localleader>li"] = {
							layerdescc = "LIST",
							i = "pivot.list.invert",
							t = "pivot.list.toggle",
						},
						["<localleader>t"] = {
							layerdesc = "TODO",
							a = "qol.todo-items.todo.task-ambiguous",
							c = "qol.todo-items.todo.task-cancelled",
							d = "qol.todo-items.todo.task-done",
							h = "qol.todo-items.todo.task-on-hold",
							i = "qol.todo-items.todo.task-important",
							p = "qol.todo-items.todo.task-pending",
							r = "qol.todo-items.todo.task-recurring",
							u = "qol.todo-items.todo.task-undone",
						},
					},
				},
				{
					mode = { "v" },
					keys = {
						["<"] = "promo.demote.range",
						[">"] = "promo.promote.range",
					},
				},
			},
		},
	},
	{
		mode = { "n" },
		keys = {
			["<localeader>L"] = "<cmd>Neorg render-latex<cr>",
			["<localeader>C"] = "<cmd>Neorg toggle-concealer<cr>",
		},
	},
}
util.keymapsForVim(global_keymaps)
-- require("lz.n").load({
-- 	{
-- 		"neorg",
-- 		-- cmd = { "Neorg" },
-- 		-- ft = { "neorg", "norg" },
-- 		event = "DeferredUIEnter",
--
-- 		after = function()
-- 			require("neorg").setup(config)
-- 			vim.api.nvim_create_autocmd("FileType", {
-- 				pattern = "norg",
-- 				callback = function()
-- 					util.keymapsForVim(keymaps)
-- 				end,
-- 			})
-- 		end,
-- 	},
-- })

require("neorg").setup(config)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "norg",
	callback = function()
		util.keymapsForVim(keymaps)
	end,
})
