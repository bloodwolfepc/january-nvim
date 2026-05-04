local util = "main.util"

keymaps = {
	{
		mode = { "n" },
		builder = function(p)
			require("dap")[p]()
		end,
		desc = function(p)
			return "DAP: " .. p
		end,
		keys = {
			["<leader>h"] = {
				d = "continue",
				i = "step_into",
				o = "step_over",
				h = "step_out",
				j = "toggle_breakpoint",
				l = "toggle",
				k = {
					function()
						dap.set_breakpoint(vim.fn.input("DAP set_breakpoint: "))
					end,
					{ desc = "DAP set_breakpoint: " },
				},
			},
		},
	},
	{
		mode = { "n" },
		keys = {
			["<leader>hp"] = {
				function()
					require("dapui.toggle")
				end,
				{ desc = "DAPUI" },
			},
		},
	},
}

require("lz.e").load({
	event = "DeferredUIEnter",
	load = function(name)
		util.addPacks(name, {
			"nvim-dap-ui",
			"nvim-dap-virtual-text",
		})
	end,
	after = function()
		require("nvim-dap-virtual-text").setup()
		util.keymapsForVim(keymaps)
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end,
})
