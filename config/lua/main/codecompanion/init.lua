local util = require("main.util")
local prompts_dir = (vim.api.nvim_get_runtime_file("lua/main/codecompanion/prompts/", false))[1]
	or vim.notfily("Prompts directory not found", vim.log.levels.ERROR)
local get_prompt = function(prompt)
	return table.concat(vim.fn.readfile(prompts_dir .. prompt .. ".md"), "\n")
end
local system = util.get_distro() or vim.loop.os_uname().sysname or "POSIX-compliant"

local system_prompt = function(ctx)
	local prompt = string.format(get_prompt("system"), system)
	local additional_context = [[Additional context:
All non-code text responses must be written in the %s language.
The current date is %s.
The user's Neovim version is %s.
The user is working on a %s machine. Please respond with system specific commands if applicable.
]]
	return prompt .. "\n\n" .. string.format(additional_context, ctx.language, ctx.date, ctx.nvim_version, system)
end

local config = {
	log_level = "DEBUG",
	prompts_library = {
		markdown = {
			dirs = table.insert({}, prompts_dir), --trailing slash?
		},
	},

	display = {
		diff = {
			enabled = true,
			threshold_for_chat = 12,
		},
		chat = {
			auto_scroll = false,
		},
		action_palette = {
			width = 95,
			height = 10,
			prompt = "Prompt ",
			provider = "telescope",
			opts = {
				show_preset_actions = true,
				show_preset_prompts = false,
				title = "CodeCompanion Actions",
			},
		},
	},
	adapters = {
		acp = {
			opts = {
				show_presets = false,
			},
		},
		http = {
			opts = {
				show_presets = false,
			},
		},
		openai = function()
			return require("codecompanion.adapters").extend("openai", {
				schema = {
					model = {
						default = "gpt-4.1",
					},
				},
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
			adapter = "openai",
			model = "gpt-4.1",
			roles = {
				lls = function(adapter)
					return "CodeCompanion@" .. adapter.formatted_name
				end,
				user = function()
					return (vim.env.USER or "user") .. "@" .. (vim.loop.os_gethostname() or system)
				end,
			},
			keymaps = {
				options = {},
				completion = {},
				clear = {
					modes = { n = "<localleader>x" },
					callback = "keymaps.clear",
					description = "CC: Clear",
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
			adapter = "openai",
			model = "gpt-4.1",
		},
		cmd = {
			adapter = "openai",
			model = "gpt-4.1",
		},
	},
	extensions = {
		spinner = {},
		history = {
			enabled = true,
			opts = {
				keymap = "gh",
				save_chat_keymap = "<C-p>",
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
						return original_title .. " [" .. os.date("%Y-%m-%d") .. "]"
					end,
				},
				continue_last_chat = true,
				delete_on_clearing_chat = false,
				dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
				summary = {
					create_summary_keymap = "<localleader>cs",
					browse_summaries_keymap = "<localleader>bs",
				},

				-- Memory system (requires VectorCode CLI)
				-- memory = {
				-- 	-- Automatically index summaries when they are generated
				-- 	auto_create_memories_on_summary_generation = true,
				-- 	-- Path to the VectorCode executable
				-- 	vectorcode_exe = "vectorcode",
				-- 	-- Tool configuration
				-- 	tool_opts = {
				-- 		-- Default number of memories to retrieve
				-- 		default_num = 10,
				-- 	},
				-- 	-- Enable notifications for indexing progress
				-- 	notify = true,
				-- 	-- Index all existing memories on startup
				-- 	-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
				-- 	index_on_startup = false,
				-- },
			},
		},
	},
}

local keymaps = {
	{
		mode = { "n", "v" },
		builder = function(p)
			return vim.cmd("CodeCompanion" .. p)
		end,
		desc = function(p)
			return "Codecompainion: " .. p
		end,
		keys = {
			["<leader>"] = {
				a = {
					layerdesc = "Codecompainion",
					i = "Chat Toggle",
					a = "Actions",
					C = "CLI",
					d = "Command",
				},
			},
		},
	},
}

keymaps = {
	{
		mode = { "n", "v" },
		builder = function(p)
			return vim.cmd("CodeCompanion" .. p)
		end,
		desc = function(p)
			return "Codecompainion: " .. p
		end,
		keys = {
			["<leader>"] = {
				a = {
					layerdesc = "Codecompainion",
					i = "Chat Toggle",
					a = "Actions",
					C = "CLI",
					d = "Command",
				},
			},
		},
	},
}

local local_keymaps = {
	{
		mode = { "n" },
		builder = function()
			return vim.print("hi")
		end,
		desc = function(p)
			return "CC: " .. p
		end,
		opts = { buffer = true },
		keys = {
			["<localleader>"] = {
				x = "clear",
				n = "nothing",
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
			})
		end,
		after = function()
			require("codecompanion").setup(config)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "codecompanion" },
				callback = function(ev)
					-- util.keymapsForVim(local_keymaps)
					-- Issue: https://github.com/folke/which-key.nvim/pull/942
					-- Fix: https://github.com/felixge/dotfiles/commit/eaa1492d2220e58be7bd713e06d7496555a824cf
					vim.defer_fn(function()
						local ok, wk_buf = pcall(require, "which-key.buf")
						if ok and wk_buf.bufs[ev.buf] then
							wk_buf.bufs[ev.buf]:clear()
						end
					end, 0)
					local opts = {
						buffer = ev.buf,
						silent = false,
						noremap = true,
						desc = "helo",
					}

					vim.keymap.set("n", "<localleader>", "", opts)
					vim.keymap.set("n", "<localleader>w", "", opts)
				end,
			})
		end,
	},
})

vim.keymap.set("n", "<leader>ac", function()
	vim.cmd("split | terminal aichat")
end, { desc = "aichat session" })

--[[
TODO:prompt snippet
  from what is provided in this snippet:
    <here> <- inserted from visual mode
  what does this mean:
    <cursor insert>
]]
