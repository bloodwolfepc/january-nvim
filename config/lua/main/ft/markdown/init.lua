local util = require("main.util")
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
		ft = { "markdown", "Avante" },
		after = function()
			require("render-markdown").setup({
				file_types = { "markdown", "Avante" },
				latex = {
					enabled = true,
				},
			})
		end,
	},
})
