return {
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
}
