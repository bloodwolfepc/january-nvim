require("main.opts")

require("theme").load()

require("main.oil")
require("main.telescope")
require("main.treesitter")
require("main.yanky")
require("main.avante")
require("main.completion")

vim.diagnostic.config({
	virtual_text = true,
	virtual_lines = false,
})

require("lz.n").load({
	{
		"nvim-web-devicons",
		event = "DeferredUIEnter",
		after = function()
			require("nvim-web-devicons").setup({})
		end,
	},
	{
		"indent-blankline.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("ibl").setup({
				indent = {
					highlight = { "ibl1", "ibl2", "ibl3", "ibl4", "ibl5", "ibl6" },
				},
				scope = {
					highlight = "IblScope",
				},
			})
		end,
	},
	{
		"nvim-colorizer.lua",
		event = "BufEnter",
		after = function()
			require("colorizer").setup({
				always_update = true,
				RGB = true,
				RGBA = true,
				RRGGBB = true,
				RRGGBBAA = true,
				AARRGGBB = true,
				rgb_fn = true,
				hsl_fn = true,
				css = true,
				css_fn = true,
				tailwind = true,
				tailwind_opts = {
					update_names = true,
				},
			})
			require("colorizer").attach_to_buffer()
		end,
	},

	{
		"vim-illuminate",
		event = "BufEnter",
		after = function()
			require("illuminate").configure({
				delay = 0,
				under_cursor = false,
			})
		end,
	},
	{
		"undotree",
		cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo" },
		keys = { { "<leader>U", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree" } },
		before = function()
			vim.g.undotree_WindowLayout = 1
			vim.g.undotree_SplitWidth = 40
		end,
	},

	{
		"fidget.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("fidget").setup()
		end,
	},
	{
		"eyeliner.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("eyeliner").setup()
		end,
	},
	{
		"lualine.nvim", --TODO: try galaxyline
		event = "DeferredUIEnter",
		after = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = nil,
				},
			})
		end,
	},
	{
		"marks.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("marks").setup()
		end,
	},
	{
		"todo-comments.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("todo-comments").setup()
		end,
	},
	{
		"nvim-surround",
		event = "DeferredUIEnter",
		after = function()
			require("nvim-surround").setup()
		end,
	},

	{
		"neorg",
		cmd = { "Neorg" },
		ft = { "neorg" },
		after = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/src/notebook2",
							},
							default_workspace = "notes",
						},
					},
				},
			})
		end,
	},
	{
		"wrapping.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("wrapping").setup({
				opts = {
					create_commands = false,
					create_keymaps = false,
					notify_on_switch = false,
				},
			})
			vim.api.nvim_command("highlight ColorColumn ctermbg=darkgrey guibg=#3C3836")
			local original_colorcolumn = vim.opt.colorcolumn:get()

			vim.keymap.set("n", "]ow", function()
				require("wrapping").hard_wrap_mode()
				vim.opt.colorcolumn = original_colorcolumn
			end, { desc = "hard wrapping" })

			vim.keymap.set("n", "[ow", function()
				require("wrapping").soft_wrap_mode()
				vim.opt.colorcolumn = ""
			end, { desc = "soft wrapping" })

			vim.keymap.set("n", "yow", function()
				require("wrapping").toggle_wrap_mode()
				local current_wrap = vim.wo.wrap
				if current_wrap then
					vim.opt.colorcolumn = ""
				else
					vim.opt.colorcolumn = original_colorcolumn
				end
			end, { desc = "toggle wrapping" })
		end,
	},
	{
		"which-key.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("which-key").setup()
			require("which-key").add({
				{ "<leader>f", group = "telescope" },
				{ "<leader>f_", hidden = true },
			})
		end,
	},
})
