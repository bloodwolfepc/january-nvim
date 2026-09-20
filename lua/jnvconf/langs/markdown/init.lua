local util = require("jnvconf.util")
-- local config = {}
local keymaps = {
	mode = { "n" },
	opts = { buffer = true },
	desc = function(p)
		return "MD: " .. p
	end,
	keys = {
		{
			["<leader>s"] = {
				["sp"] = "<cmd>MarkdownPreview<cr>",
				["ss"] = "<cmd>MarkdownPreviewStop<cr>",
				["st"] = "<cmd>MardownPreviewToggle<cr>",
			},
		},
	},
}

require("lz.n").load({
	{
		"markdown-preview.nvim",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		ft = { "markdown", "md" },
		keys = util.keymapsForLzn(keymaps),
		-- after = function()
		--
		-- end,
	},
	{
		"render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
		after = function()
			require("render-markdown").setup({
				file_types = { "markdown", "codecompanion" },
				latex = {
					enabled = true,
				},
			})
		end,
	},
})

local group = vim.api.nvim_create_augroup("CustomMarkdownHighlight", { clear = true })

vim.api.nvim_create_autocmd({ "FileType", "ColorScheme" }, {
	group = group,
	pattern = { "markdown" },
	callback = function()
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.bo.expandtab = true
		vim.bo.indentexpr = ""
		vim.bo.cindent = false
		vim.bo.smartindent = false

		vim.cmd([[silent! syntax clear MarkdownCustomTag]])
		vim.cmd([[silent! syntax clear MarkdownCustomSubject]])
		vim.cmd([[silent! syntax clear MarkdownCustomLine]])

		vim.cmd([[
      syntax region MarkdownCustomLine start=/^#\w\+/ end=/$/ contains=MarkdownCustomTag,MarkdownCustomSubject keepend
      syntax match MarkdownCustomTag /#\w\+/ contained containedin=MarkdownCustomLine
      syntax match MarkdownCustomSubject /\s\+\zs\w\+/ contained containedin=MarkdownCustomLine
    ]])

		vim.api.nvim_set_hl(0, "MarkdownCustomTag", {
			fg = "#c678dd",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MarkdownCustomSubject", {
			fg = "#61afef",
		})
	end,
})
