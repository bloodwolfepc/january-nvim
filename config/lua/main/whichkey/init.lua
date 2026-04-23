return {
  {
    "which-key.nvim",
    event = "DeferredUIEnter",
    dep_of = "ChatGPT.nvim",
    after = function ()
      require('which-key').setup({
      })
      require('which-key').add{
        { "<leader>f", group = "telescope" },
        { "<leader>f_", hidden = true }
      }
    end
  }
}
