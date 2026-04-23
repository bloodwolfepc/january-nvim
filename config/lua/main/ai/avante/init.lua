local kb = function()
  local mapKeys = require("utils.mapKeys")
  local api = require("avante.api")
  local kb2 = {
    ["<leader>"] = {
      a = {
        a = { function() api.ask() end, "ask" },
        e = { function() api.edit() end, "edit" },
        t = { function() api.toggle() end, "toggle" },
        r = { function() api.refresh() end, "refresh" },
      }
    }
  }
  local kb1 = {
    n = kb2,
    v = kb2
  }
  return mapKeys.lze(kb1)
end
return {
  {
    "avante.nvim",
    for_cat = "ai",
    event = "DeferredUIEnter",
    --keys = (kb)(),
    -- cmd = {
    --   "AvanteAsk",
    --   "AvanteEdit",
    --   "AvanteBuild",
    --   "AvanteClear",
    --   "AvanteToggle",
    --   "AvanteRefresh",
    --   "AvanteSwitchProvider",
    -- },
    after = function()
      require("avante").setup({
        provider = "openai",
        openai = {
          --api_key_name = "cmd:gpg -q --decrypt ~/src/config/secrets/key.txt"
        },
        hints = { enabled = false },
        windows = {
          ask = { border = "single" },
          edit = { border = "single" },
          sidebar_header = { rounded = false },
        },
        mappings = {
          diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
          },
          suggestion = {
            accept = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
          jump = {
            next = "]]",
            prev = "[[",
          },
          submit = {
            normal = "<CR>",
            insert = "<C-s>",
          },
          ask = "<leader>aa",
          edit = "<leader>ae",
          refresh = "<leader>ar",
          focus = "<leader>af",
          toggle = {
            default = "<leader>at",
            debug = "<leader>ad",
            hint = "<leader>ah",
            suggestion = "<leader>as",
            repomap = "<leader>aR",
          },
          sidebar = {
            apply_all = "A",
            apply_cursor = "a",
            retry_user_request = "r",
            edit_user_request = "e",
            switch_windows = "<Tab>",
            reverse_switch_windows = "<S-Tab>",
            remove_file = "d",
            add_file = "@",
            close = { "<Esc>", "q" },
            close_from_input = nil,
          },
          files = {
            add_current = "<leader>ac",
          },
          select_model = "<leader>a?",
        },
      })
    end,
  }
}
