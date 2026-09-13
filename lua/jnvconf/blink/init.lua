local util = require("jnvconf.util")
local module = require("jnvconf.module")

local config = {
	keymap = {
		preset = "default",
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = {
			auto_show = false,
		},
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
	cmdline = {
		sources = {
			"path",
			"cmdline",
		},
	},
	sources = {
		default = require("jnvconf.blink.defsources"),
		providers = require("jnvconf.blink.defproviders"),
	},
}

require("lz.n").load({
	{
		"blink.cmp",
		event = "DeferredUIEnter",
		load = function(name)
			local packs = {
				"blink-cmp-dictionary",
				"blink-cmp-words",
				"blink-cmp-git",
				"blink-cmp-latex",
				"blink-emoji.nvim",
			}

			module.forModules(function(m)
				if type(m) ~= "table" then
					return
				end

				local blink = m.blink
				if type(blink) ~= "table" then
					return
				end

				if type(blink.addpacks) == "table" then
					vim.list_extend(packs, blink.addpacks)
				end

				if type(blink.config) == "table" then
					config = vim.tbl_deep_extend("force", config, blink.config)
				end
			end)

			util.addPacks(name, packs)
		end,
		after = function()
			require("blink.cmp").setup(config)
		end,
	},
})
