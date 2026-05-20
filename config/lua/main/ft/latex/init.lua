local util = require("main.util")
local keymaps = {
	{
		mode = { "n" },
		builder = function(p)
			return vim.cmd(':execute "normal \\<Plug>(vimtex-' .. p .. ')"')
		end,
		desc = function(p)
			return "VIMTEX: " .. p
		end,
		keys = {
			["<leader>"] = {
				s = {
					i = "info",
					I = "info-full",
					t = "toc-open",
					T = "toc-toggle",
					p = "view",
					r = "reverse-search",
					c = "compile",
					q = "stop",
					Q = "stop-all",
					e = "errors",
					o = "compile-output",
					s = "status",
					S = "status-all",
					g = "clean",
					m = "imaps-list",
					x = "reload",
					f = "toggle-main",
				},
			},
		},
	},
}

require("lz.n").load({
	{
		"vimtex",
		-- ft = { "tex", "bib" },
		event = "DeferredUIEnter",
		after = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_method = "latexmk"
			--vim.g.vimtex_mappings_enabled = false
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "tex",
				callback = function()
					util.keymapsForVim(keymaps) -- TOOD: If buffer in not focused, ummap
				end,
			})
		end,
	},
})
