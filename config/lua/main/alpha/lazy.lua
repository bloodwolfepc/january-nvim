return {
  {
    "alpha.nvim",
    cmd = { "Alpha" },
    on_require = { "alpha" },
    --lazy = false,
    after = function (plugin)
      --local dashboard = require("alpha.themes.dashboard")
      --dashboard.section.header.val = { [[ TEST ]] }
      --
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
      --require('alpha').setup {

        --dashboard.config
      --}
    end
  }
}
