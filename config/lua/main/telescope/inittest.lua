local keymap = require("lz.n").keymap({
	"telescope.nvim",
	cmd = "Telescope",
	after = function()
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
})

keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>")
keymap.set("n", "<leader>tg", function()
	require("telescope.builtin").live_grep()
end)
