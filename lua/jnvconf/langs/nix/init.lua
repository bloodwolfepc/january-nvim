return {
	lsp = {
		nixd = {},
	},
	conform = {
		formatters_by_ft = {
			nix = { "nixfmt", lsp_format = "fallback" },
		},
	},
	telescope = {
		load_extension = { "manix", "telescope-manix" },
	},
	blink = {
		addpacks = { "blink-cmp-nixpkgs-maintainers" },
	},
}
