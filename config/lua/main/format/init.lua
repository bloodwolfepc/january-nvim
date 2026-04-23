require("lze").load {
  {
    "conform.nvim",
    for_cat = "format",
    lazy = false,
    after = function()
      local conform = require("conform")
      conform.setup({
        formatters = {
          lilypond = {
            command = "ly",
            args = { "reformat" },
          },
        },
        formatters_by_ft = {
          rust = { "rustfmt", lsp_format = "fallback" },
          nix = { "nixfmt", lsp_format = "fallback" },
          lua = { "stylua", lsp_format = "fallback" },
          lilypond = { "lilypond" },
        },
      })
    end,
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
