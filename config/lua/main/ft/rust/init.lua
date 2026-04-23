--local extraUtils = require("utils.extraUtils")
return {
  {
    "rustaceanvim",
    for_cat = "rust",
    ft = "rust",
    event = "DeferredUIEnter",
    lazy = false,
    load = function(name)
      vim.cmd.packadd("rustaceanvim")
    end,
    after = function()
      local cfg = require("rustaceanvim.config")

      vim.g.rustaceanvim = {
        version = "^6",
        lazy = false,
        tools = { },
        server = {
          on_attach = function(client, bufnr)
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
            },
          },
        },
        dap = {
        },
      }

      local bufnr = vim.api.nvim_get_current_buf()
      vim.keymap.set(
        "n",
        "<leader>sA",
        function()
          vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
          -- or vim.lsp.buf.codeAction() if you don't want grouping.
        end,
        { silent = true, buffer = bufnr }
      )
      vim.keymap.set(
        "n",
        "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
        function()
          vim.cmd.RustLsp({'hover', 'actions'})
        end,
        { silent = true, buffer = bufnr }
      )
    end,
  }
}
