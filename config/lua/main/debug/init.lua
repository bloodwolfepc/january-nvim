

local extraUtils = require('utils.extraUtils')
require('lze').load {
  "nvim-dap",
  for_cat = { cat = 'debug', defult = false },
  load = function(name) extraUtils.addPacks(
    name,
    {
      "nvim-dap-ui",
      "nvim-dap-virtual-text"
    }
  )end,
  after = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local mapKeys = require('utils.mapKeys')
    local function cmd(name)
      return { dap[name], "dap." .. name }
    end
    local kb = {
      n = {
        ["<leader>"] = {
          h = {
            d = cmd("continue"),
            i = cmd("step_into"),
            o = cmd("step_over"),
            h = cmd("step_out"),
            j = cmd("toggle_breakpoint"),
            l = cmd("toggle"),
            k = {
              function()
                dap.set_breakpoint(vim.fn.input 'dap.set_breakpoint: ')
              end,
              "dap.set_breakpoint"
            },
            p = { dapui.toggle, "dapui.toggle" }
          }
        }
      }
    }
    require("nvim-dap-virtual-text").setup()
    mapKeys.vim(kb)

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

  end
}
