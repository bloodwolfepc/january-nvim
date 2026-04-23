local kb = function()
  local mapKeys = require("utils.mapKeys")
  local function cmd(cmd1)
    return { "<Plug>(vimtex-" .. cmd1 .. ")",
    cmd1 }
  end
  local kb1 = {
    ["<leader>"] = {
      s = {
        i = cmd("info"),
        I = cmd("info-full"),
        t = cmd("toc-open"),
        T = cmd("toc-toggle"),
        p = cmd("view"),
        r = cmd("reverse-search"),
        c = cmd("compile"),
        q = cmd("stop"),
        Q = cmd("stop-all"),
        e = cmd("errors"),
        o = cmd("compile-output"),
        s = cmd("status"),
        S = cmd("status-all"),
        g = cmd("clean"),
        m = cmd("imaps-list"),
        x = cmd("reload"),
        f = cmd("toggle-main")
      },
    },
    -- dse = cmd("env-delete"),
    -- dsc = cmd("env-cmd-delete"),
  }
  return mapKeys.vim(kb1)
end
return {
  {
    "vimtex",
    for_cat = "latex",
    event = "DeferredUIEnter",
    lazy = false,
    after = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      --vim.g.vimtex_mappings_enabled = false
      kb()
    end,
  },

  {
    "texlab",
    enabled = nixCats("latex") or false,
    lsp = {
      filetypes = { "tex", "bib" },
    },
  },
}
