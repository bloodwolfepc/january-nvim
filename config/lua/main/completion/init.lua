local util = require("main.util")
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
	sources = {
		default = {
			"path",
			"lsp",
			"buffer",
			"snippets",
			"lazydev",
			"dictionary",
			"emoji",
			"word_net_dictionary",
			"word_net_thesaurus",
		},
		providers = {
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
			util.addPacks(name, {
				"blink-cmp-dictionary",
				"blink-cmp-words",
				"blink-cmp-git",
				"blink-emoji.nvim",
			})
		end,
		after = function()
			require("blink.cmp").setup(config)
		end,
	},
})
