return {
	{
		"markdown-preview.nvim",
		lazy = false,
		for_cat = "markdown",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		ft = "markdown",
		keys = {
			{ "<leader>ssp", "<cmd>MarkdownPreview <CR>", mode = { "n" }, noremap = true, desc = "markdown preview" },
			{
				"<leader>ss",
				"<cmd>MarkdownPreviewStop <CR>",
				mode = { "n" },
				noremap = true,
				desc = "markdown preview stop",
			},
			{
				"<leader>st",
				"<cmd>MarkdownPreviewToggle <CR>",
				mode = { "n" },
				noremap = true,
				desc = "markdown preview toggle",
			},
		},
		before = function()
			vim.g.mkdp_auto_close = 0
		end,
	},
	{
		"render-markdown.nvim",
		for_cat = "markdown",
		ft = "markdown",
		event = "DeferredUIEnter",
		after = function()
			require("render-markdown").setup({
				file_types = { "markdown", "vimwiki" },
				latex = {
					enabled = true,
				},
			})
			vim.treesitter.language.register("markdown", "vimwiki") --register markdown as parser for vimwiki files
		end,
	},
	{
		"vimwiki",
		for_cat = "markdown",
		ft = "markdown",
		event = "DeferredUIEnter",
		after = function()
			vim.g.vimwiki_auto_chdir = 1
			vim.g.vimwiki_list = {
				{
					path = "~/notebook",
					syntax = "markdown",
					ext = ".md",
					diary_rel_path = "personal/diary",
					diary_index = "diary",
				},
			}
		end,
	},
}
