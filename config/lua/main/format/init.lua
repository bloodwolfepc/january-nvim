require("lz.n").load({
	{
		"conform.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("conform").setup({
				format_on_save = function(bufnr)
					-- Disable "format_on_save lsp_fallback" for languages that don't
					-- have a well standardized coding style. You can add additional
					-- languages here or re-enable it for the disabled ones.
					local disable_filetypes = { c = true, cpp = true }
					if disable_filetypes[vim.bo[bufnr].filetype] then
						return nil
					else
						return {
							timeout_ms = 500,
							lsp_format = "fallback",
						}
					end
				end,
				formatters = {
					lilypond = {
						command = "ly",
						args = { "reformat" },
					},
				},
				formatters_by_ft = {
					c = { "clang_format", lsp_format = "fallback" },
					rust = { "rustfmt", lsp_format = "fallback" },
					nix = { "nixfmt", lsp_format = "fallback" },
					lua = { "stylua", lsp_format = "fallback" },
					typst = { "typstyle" },
					lilypond = { "lilypond" },
					kdl = { "kdlfmt" },
				},
			})
		end,
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
