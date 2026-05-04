require("lz.n").load({
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
								notebook = "~/src/notebook2",
							},
							default_workspace = "notebook",
						},
					},
				},
			})
		end,
	},
})
