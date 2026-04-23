require("lze").load {
  {
    "nvim-lint",
    for_cat = "lint",
    event = "DeferredUIEnter",
    after = function()
    local lint = require("lint")
      lint = {
        linters = {
          lilypond = lilypond_parser("./openlilyLib")
        },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
