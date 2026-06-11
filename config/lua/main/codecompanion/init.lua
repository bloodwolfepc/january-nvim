local util = require("main.util")
local prompt_util = require("main.codecompanion.prompts.util")

local system_prompt = function(_)
	local prompt = string.format(prompt_util.get_prompt_no_md("system"), prompt_util.system)
	local additional_context = prompt_util.context
	return prompt .. "\n\n" .. additional_context
end

local keymaps = {
	{
		mode = { "n", "v" },
		builder = function(p)
			return vim.cmd("CodeCompanion" .. p)
		end,
		desc = function(p)
			return "CC: " .. p
		end,
		keys = {
			["<leader>"] = {
				a = {
					layerdesc = "Codecompainion",
					i = "Chat Toggle",
					a = "Actions",
					C = "CLI",
					c = "Command",
					e = "/educate",
					m = "/commit",
					d = "/explain",
					l = "/lsp",
					f = "/fix",
					t = "/test",
				},
			},
		},
	},
}

local local_keymaps = {
	{
		mode = { "n" },
		builder = function(p)
			require("codecompanion.interactions.chat.keymaps")[p].callback()
		end,
		desc = function(p)
			return "CC: " .. p
		end,
		opts = { buffer = true, silent = true, noremap = true },
		keys = {
			["<localleader>"] = {
				["?"] = "options",
				["b"] = {
					layerdesc = "CC: buffer",
				},
				["t"] = {
					layerdesc = "CC: tools",
				},
				["s"] = {
					layerdesc = "CC: summary",
				},
			},
		},
	},
}

local config = {
	log_level = "DEBUG",
	prompt_library = {
		markdown = {
			dirs = { prompt_util.prompts_dir, vim.fn.getcwd() .. "/.prompts" },
		},
	},
	display = {
		chat = {
			auto_scroll = false,
			intro_message = "✨Helloworld",
			show_settings = false,
		},
		action_palette = {
			width = 95,
			height = 10,
			prompt = "Prompt ",
			provider = "telescope",
			opts = {
				show_preset_actions = true,
				show_preset_prompts = true,
				title = "CodeCompanion Actions",
			},
		},
		diff = {
			enabled = true,
			threshold_for_chat = 12,
		},
	},
	adapters = {
		acp = {
			opts = {
				show_presets = false,
				show_model_choices = true,
			},
		},
		http = {
			opts = {
				show_presets = false,
				show_model_choices = true,
			},
		},
		openai = function()
			return require("codecompanion.adapters").extend("openai", {
				-- schema = {
				-- 	model = {
				-- 		default = "gpt-5.4-mini",
				-- 	},
				-- },
				env = {
					api_key = os.getenv("OPENAI_API_KEY"),
				},
			})
		end,
	},
	interactions = {
		opts = {
			date_format = "%Y-%m-%d",
		},
		chat = {
			adapter = {
				name = "openai",
				model = "gpt-5.4-mini",
			},
			roles = {
				llm = function(adapter)
					return "CodeCompanion@" .. adapter.formatted_name
				end,
				user = (vim.env.USER or "user") .. "@" .. (vim.loop.os_gethostname() or prompt_util.system),
			},
			keymaps = {
				options = false,
				completion = {
					modes = { i = "<C-_>" },
					index = 1,
					callback = "keymaps.completion",
					description = "CC: completion",
					opts = { chat = { show_in_action_palette = false } },
				},
				send = {
					modes = {
						n = { "<cr>", "<c-cr>" },
						i = "<c-cr>",
					},
					index = 2,
					callback = "keymaps.send",
					description = "CC: send",
				},
				regenerate = {
					modes = { n = "<localleader>r" },
					index = 3,
					callback = "keymaps.regenerate",
					description = "CC: regenerate",
				},
				close = {
					modes = {
						n = "<localleader>Q",
						i = "<C-c>",
					},
					index = 4,
					callback = "keymaps.close",
					description = "CC: close",
				},
				stop = {
					modes = { n = "<localleader>q" },
					index = 5,
					callback = "keymaps.stop",
					description = "cc: stop",
				},
				clear = {
					modes = { n = "<localleader>x" },
					index = 6,
					callback = "keymaps.clear",
					description = "CC: clear",
				},
				codeblock = {
					modes = { n = "<localleader>c" },
					index = 7,
					callback = "keymaps.codeblock",
					description = "CC: codeblock",
				},
				yank_code = {
					modes = { n = "<localleader>y" },
					index = 8,
					callback = "keymaps.yank_code",
					description = "CC: yank_code",
				},
				buffer_sync_all = {
					modes = { n = "<localleader>ba" },
					index = 9,
					callback = "keymaps.buffer_sync_all",
					description = "CC: buffer_sync_all",
					opts = { chat = { show_in_action_palette = false } },
				},
				buffer_sync_diff = {
					modes = { n = "<localleader>bd" },
					index = 10,
					callback = "keymaps.buffer_sync_diff",
					description = "CC: buffer_sync_diff",
					opts = { chat = { show_in_action_palette = false } },
				},
				next_chat = {
					modes = { n = "<localleader>}" },
					index = 11,
					callback = "keymaps.next_chat",
					description = "CC: next_chat",
				},
				previous_chat = {
					modes = { n = "<localleader>{" },
					index = 12,
					callback = "keymaps.previous_chat",
					description = "CC: previous_chat",
				},
				next_header = {
					modes = { n = "]]" },
					index = 13,
					callback = "keymaps.next_header",
					description = "CC: next_header",
				},
				previous_header = {
					modes = { n = "[[" },
					index = 14,
					callback = "keymaps.previous_header",
					description = "Jump to the previous header",
				},
				change_adapter = {
					modes = { n = "<localleader>a" },
					index = 15,
					callback = "keymaps.change_adapter",
					description = "CC: change_adapter",
				},
				fold_code = {
					modes = { n = "<localleader>f" },
					index = 15,
					callback = "keymaps.fold_code",
					description = "CC: fold_code",
				},
				debug = {
					modes = { n = "<localleader>d" },
					index = 16,
					callback = "keymaps.debug",
					description = "CC: debug",
				},
				system_prompt = {
					modes = { n = "<localleader>p" },
					index = 17,
					callback = "keymaps.toggle_system_prompt",
					description = "CC: toggle_system_prompt",
				},
				rules = {
					modes = { n = "<localleader>r" },
					index = 18,
					callback = "keymaps.clear_rules",
					description = "CC: clear_rules",
				},
				clear_approvals = {
					modes = { n = "<localleader>tx" },
					index = 19,
					callback = "keymaps.clear_approvals",
					description = "CC: clear_approvals",
				},
				yolo_mode = {
					modes = { n = "<localleader>ty" },
					index = 20,
					callback = "keymaps.yolo_mode",
					description = "CC: yolo_mode",
				},
				goto_file_under_cursor = {
					modes = { n = "<localleader>o" },
					index = 21,
					callback = "keymaps.goto_file_under_cursor",
					description = "CC: goto_file_under_cursor",
				},
				copilot_stats = {
					modes = { n = "<localleader>S" },
					index = 22,
					callback = "keymaps.copilot_stats",
					description = "CC: copilot_status",
				},
				_btw = {
					modes = { n = "<localleader>M" },
					callback = "keymaps.btw",
					description = "CC: btw",
				},
			},
			opts = {
				completion_provider = "blink",
				system_prompt = function(ctx)
					return system_prompt(ctx)
				end,
			},
			slash_commands = {
				["file"] = {
					opts = {
						provider = "telescope",
					},
				},
			},
		},
		inline = {
			adapter = {
				name = "openai",
				model = "gpt-5.4-mini",
			},
		},
		cmd = {
			adapter = {
				name = "openai",
				model = "gpt-5.4-mini",
			},
		},
	},
	extensions = {
		spinner = {},
		vectorcode = {
			opts = {
				tool_group = {
					enabled = true,
					extras = {},
					collapse = false,
				},
				tool_opts = {
					["*"] = {},
					ls = {},
					vectorise = {},
					query = {
						max_num = { chunk = -1, document = -1 },
						default_num = { chunk = 50, document = 10 },
						include_stderr = false,
						use_lsp = false,
						no_duplicate = true,
						chunk_mode = false,
						summarise = {
							enabled = false,
							query_augmented = true,
						},
					},
					files_ls = {},
					files_rm = {},
				},
			},
		},
		history = {
			enabled = true,
			opts = {
				keymap = "<localleader>h",
				save_chat_keymap = "<localleader>w",
				auto_save = true,
				expiration_days = 0,
				picker = "telescope",
				picker_keymaps = {
					rename = { n = "r", i = "<M-r>" },
					delete = { n = "d", i = "<M-d>" },
					duplicate = { n = "<C-y>", i = "<C-y>" },
				},
				auto_generate_title = true,
				title_generation_opts = {
					adapter = "openai",
					model = "gpt-4o",
					refresh_every_n_prompts = 0,
					format_title = function(original_title)
						return original_title .. " [" .. os.date("%Y-%m-%d-%H-%M-%S") .. "]"
					end,
				},
				continue_last_chat = false,
				delete_on_clearing_chat = false,
				dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
				summary = {
					create_summary_keymap = "<localleader>sc",
					browse_summaries_keymap = "<localleader>sb",
				},

				memory = {
					auto_create_memories_on_summary_generation = true,
					vectorcode_exe = "vectorcode",
					tool_opts = {
						default_num = 10,
					},
					notify = true,
					index_on_startup = false,
				},
			},
		},
	},
}

require("lz.n").load({
	{
		"codecompanion.nvim",
		keys = util.keymapsForLzn(keymaps),
		cmd = {
			"CodeCompanion",
			"CodeCompanionActions",
			"CodeCompanionChat",
			"CodeCompanionCLI",
			"CodeCompanionCommand",
		},
		load = function(name)
			util.addPacks(name, {
				"codecompanion-spinner.nvim",
				"codecompanion-history.nvim",
				"vectorcode.nvim",
			})
		end,
		after = function()
			require("codecompanion").setup(config)
			vim.cmd([[cab CC CodeCompanion]])
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "codecompanion" },
				callback = function(ev)
					-- Issue: https://github.com/folke/which-key.nvim/pull/942
					-- Fix: https://github.com/felixge/dotfiles/commit/eaa1492d2220e58be7bd713e06d7496555a824cf
					vim.defer_fn(function()
						local ok, wk_buf = pcall(require, "which-key.buf")
						if ok and wk_buf.bufs[ev.buf] then
							wk_buf.bufs[ev.buf]:clear()
						end
					end, 0)
					util.keymapsForVim(local_keymaps)
					-- vim.print(require("codecompanion").extensions.history.get_chats())
				end,
			})
		end,
	},
})

vim.cmd.packadd("vectorcode.nvim")
require("vectorcode").setup()

--[[
TODO:prompt snippet
  from what is provided in this snippet:
    <here> <- inserted from visual mode
  what does this mean:
    <cursor insert>

> Context:
> - <tool>file_search</tool>
> - <tool>vectorcode_files_ls</tool>

@{vectorcode_files_ls} @{file_search}
What files are most important
]]
-- commit gen from term
