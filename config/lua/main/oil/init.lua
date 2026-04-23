vim.g.loaded_netrwPlugin = 1
local kb = function()
  local oil = require("oil")
  local kb1 = {
    n = {
      ["<leader>"] = {
        o = { "<cmd>Oil<CR>", "<cmd>Oil<CR>" },
        O = {
          o = { function() return oil.open('./') end, "oil.open('./')" },
          h = { function() return oil.open('~/') end, "oil.open('~/')" },
          n = { function() return oil.open('~/notebook') end, "oil.open('~/notebook')" },
          s = { function() return oil.open('~/src') end, "oil.open('~/src')" },
        }
      }
    }
  }
  return require("utils.mapKeys").vim(kb1)
end

if nixCats('general') then
  vim.cmd.packadd('oil.nvim')
  local detail = false
  require("oil").setup({
    default_file_explorer = true,
    columns = {
      "icon",
    },
    view_options = {
      show_hidden = true
    },
    win_options = {
      wrap = false,
      signcolumn = "number",
      cursorcolumn = true,
    },
    keymaps = {
      ["<leader>s?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<leader>sv"] = "actions.select_vsplit",
      ["<leader>sh"] = "actions.select_split",
      ["<leader>st"] = "actions.select_tab",
      ["<leader>sp"] = "actions.preview",
      ["<leader>sx"] = "actions.close",
      ["<leader>sr"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["<leader>sc"] = "actions.change_sort",
      ["<leader>se"] = "actions.open_external",
      ["<leader>s."] = "actions.toggle_hidden",
      ["<leader>sg"] = "actions.toggle_trash",
      ["<leader>sd"] = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },
    },
  })
  kb()
end
