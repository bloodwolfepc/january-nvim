return {
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
	latex = {
		name = "Latex",
		module = "blink-cmp-latex",
		opts = {
			insert_command = false,
		},
	},
}
