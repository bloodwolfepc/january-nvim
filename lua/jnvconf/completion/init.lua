local util = require("jnvconf.util")

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
		default = {
			"path",
			"lsp",
			"buffer",
			"latex",
			"avante",
			"snippets",
			"lazydev",
			"dictionary",
			"emoji",
			"word_net_dictionary",
			"word_net_thesaurus",
		},
		per_filetype = {
			codecompanion = {
				"codecompanion",
				"path",
				"word_net_dictionary",
			},
		},
		providers = {
			avante = {
				module = "blink-cmp-avante",
				name = "Avante",
			},
			dictionary = {
				module = "blink-cmp-dictionary",
				name = "Dict",
				min_keyword_length = 1,
				opts = {
					force_fallback = true,
				},
			},

			word_net_dictionary = {
				name = "blink-cmp-words",
				module = "blink-cmp-words.dictionary",
				opts = {
					dictionary_search_threshold = 3,
					score_offset = 0,
					definition_pointers = { "!", "&", "^" },
				},
			},

			word_net_thesaurus = {
				name = "blink-cmp-words",
				module = "blink-cmp-words.thesaurus",
				opts = {
					score_offset = 0,
					definition_pointers = { "!", "&", "^" },
					similarity_pointers = { "&", "^" },
					similarity_depth = 2,
				},
			},

			latex = {
				name = "Latex",
				module = "blink-cmp-latex",
				opts = {
					insert_command = false,
				},
			},

			emoji = {
				module = "blink-emoji",
				name = "Emoji",
				score_offset = 15,
				opts = {
					insert = true,
					trigger = function()
						return { ":" }
					end,
					should_show_items = function()
						return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
					end,
				},
			},
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
		},
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
				"blink-emoji.nvim",
				"blink-cmp-avante",
				"blink-cmp-latex",
			}
			require("jnvconf.module").forLang(function(lang)
				local blink = lang.blink
				if type(blink) == "table" and type(blink.addpacks) == "table" then
					vim.list_extend(packs, blink.addpacks)
				end
			end)
			util.addPacks(name, packs)
		end,
		after = function()
			require("blink.cmp").setup(config)
		end,
	},
})
