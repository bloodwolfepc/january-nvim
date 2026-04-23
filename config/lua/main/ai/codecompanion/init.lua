local kb = function()
	local mapKeys = require("utils.mapKeys")
	local cmd = function(cmd1)
		return {
			"<cmd>CodeCompanion" .. cmd1 .. "<cr>",
			cmd1,
		}
	end
	local cmd1 = function(cmd1)
		return {
			"<cmd>CodeCompanion /" .. cmd1 .. "<cr>",
			cmd1,
		}
	end
	local kb2 = {
		["<leader>"] = {
			a = {
				a = cmd("Actions"),
				v = cmd("Chat Toggle"),
				e = cmd1("detailed-explain"),
				E = cmd1("explain"),
				m = cmd1("commit"),
				M = cmd1("staged-commit"),
				d = cmd1("inline-document"),
				D = cmd1("document"),
				R = cmd1("review"),
				r = cmd1("refactor"),
				n = cmd1("naming"),
				f = cmd1("why-fails"),
				F = cmd1("fix"),
				l = cmd1("lsp"),
				t = cmd1("tests"),
				q = {
					function()
						local input = vim.fn.input("Quick Chat: ")
						if input ~= "" then
							vim.cmd("CodeCompanion " .. input)
						end
					end,
					"Quick Chat",
				},
			},
		},
	}
	local kb1 = {
		n = kb2,
		v = kb2,
	}
	return mapKeys.lze(kb1)
end
return {
	{
		"codecompanion.nvim",
		for_cat = "ai",
		event = "DeferredUIEnter",
		keys = (kb)(),
		after = function()
			local prompts = require("config.ai.prompts")
			require("codecompanion").setup({
				adapters = {
					http = {
						openai = function()
							return require("codecompanion.adapters").extend("openai", {
								schema = {
									model = {
										desc = "",
										default = "gpt-4o",
										choices = {
											"gpt-4o",
											"gpt-4o-mini",
											"gpt-3.5-turbo",
										},
									},
								},
							})
						end,
						opts = {
							log_level = "DEBUG",
							system_prompt = prompts.system_prompt,
						},
					},
				},
				strategies = {
					chat = {
						adapter = "openai",
						roles = { llm = " Copilot Chat", user = "user" },
						slash_commands = {
							["file"] = {
								description = "",
								opts = {
									provider = "telescope",
								},
							},
							["buffer"] = {
								description = "",
								opts = {
									provider = "telescope",
								},
							},
						},
						keymaps = {
							send = {
								description = "Send",
							},
							close = {
								description = "Close Chat",
							},
							stop = {
								description = "Stop Request",
							},
						},
					},
					inline = {
						adapter = "openai",
						keymaps = {
							accept_change = {
								modes = { n = "ga" },
								description = "accept suggested change",
							},
							reject_change = {
								modes = { n = "gr" },
								description = "reject suggested change",
							},
						},
					},
					agent = { adapter = "openai" },
				},
				inline = {
					layout = "buffer",
				},
				display = {
					chat = {
						show_settings = true,
						window = {
							layout = "vertical",
						},
					},
				},
				prompt_library = {
					["commit"] = {
						prompts = {
							{
								role = "user",
								content = function()
									return prompts.generate_commit_message
										.. "\n\n```"
										.. vim.fn.system("git diff")
										.. "\n```"
								end,
								opts = {
									contains_code = true,
									short_name = "commit",
								},
							},
						},
					},

					["staged-commit"] = {
						strategy = "chat",
						opts = {
							index = 9,
							short_name = "staged-commit",
							auto_submit = true,
						},
						prompts = {
							{
								role = "user",
								content = function()
									return prompts.generate_commit_message
										.. "\n\n```"
										.. vim.fn.system("git diff --staged")
										.. "\n```"
								end,
								opts = {
									contains_code = true,
								},
							},
						},
					},

					["explain"] = {
						strategy = "chat",
						opts = {
							index = 4,
							default_prompt = true,
							modes = { "v" },
							short_name = "explain",
							auto_submit = true,
							user_prompt = false,
							stop_context_insertion = true,
						},
						prompts = {
							{
								role = "system",
								content = prompts.copilot_explain,
								opts = {
									visible = false,
								},
							},
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(
										context.start_line,
										context.end_line
									)

									return "Please explain how the following code works:\n\n```"
										.. context.filetype
										.. "\n"
										.. code
										.. "\n```\n\n"
								end,
								opts = {
									contains_code = true,
								},
							},
						},
					},

					["detailed-explain"] = {
						strategy = "chat",
						opts = {
							index = 4,
							default_prompt = true,
							modes = { "v" },
							short_name = "detailed-explain",
							auto_submit = false,
							user_prompt = true,
							stop_context_insertion = true,
						},
						prompts = {
							{
								role = "system",
								content = prompts.copilot_explain,
								opts = {
									visible = false,
								},
							},
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(
										context.start_line,
										context.end_line
									)

									return "From what is provded in the following code snippet:\n\n```"
										.. context.filetype
										.. "\n"
										.. code
										.. "\n```\n\n"
										.. "Please explain what the follwing means:"
										.. "\n\n"
								end,
								opts = {
									contains_code = true,
								},
							},
						},
					},

					["why-fails"] = {
						strategy = "chat",
						opts = {
							index = 4,
							default_prompt = true,
							modes = { "v" },
							short_name = "why-fails",
							auto_submit = true,
							user_prompt = false,
							stop_context_insertion = true,
						},
						prompts = {
							{
								role = "system",
								content = prompts.copilot_explain,
								opts = {
									visible = false,
								},
							},
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(
										context.start_line,
										context.end_line
									)

									return "Please explain why the following code would fail:\n\n```"
										.. context.filetype
										.. "\n"
										.. code
										.. "\n```\n\n"
								end,
								opts = {
									contains_code = true,
								},
							},
						},
					},

					["inline-document"] = {
						strategy = "inline",
						opts = {
							modes = { "v" },
							short_name = "inline-document",
							auto_submit = true,
							user_prompt = false,
							stop_context_insertion = true,
						},
						prompts = {
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(
										context.start_line,
										context.end_line
									)

									return "Please provide documentation in comment code for the following code and suggest to have better naming to improve readability.\n\n```"
										.. context.filetype
										.. "\n"
										.. code
										.. "\n```\n\n"
								end,
								opts = {
									contains_code = true,
								},
							},
						},
					},

					["document"] = {
						strategy = "chat",
						opts = {
							modes = { "v" },
							short_name = "document",
							auto_submit = true,
							user_prompt = false,
							stop_context_insertion = true,
						},
						prompts = {
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(
										context.start_line,
										context.end_line
									)

									return "Please brief how it works and provide documentation in comment code for the following code. Also suggest to have better naming to improve readability.\n\n```"
										.. context.filetype
										.. "\n"
										.. code
										.. "\n```\n\n"
								end,
								opts = {
									contains_code = true,
								},
							},
						},
					},

					["review"] = {
						strategy = "chat",
						opts = {
							index = 11,
							modes = { "v" },
							short_name = "review",
							auto_submit = true,
							user_prompt = false,
							stop_context_insertion = true,
						},
						prompts = {
							{
								role = "system",
								content = prompts.copilot_review,
								opts = {
									visible = false,
								},
							},
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(
										context.start_line,
										context.end_line
									)

									return "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability:\n\n```"
										.. context.filetype
										.. "\n"
										.. code
										.. "\n```\n\n"
								end,
								opts = {
									contains_code = true,
								},
							},
						},
					},

					["refactor"] = {
						strategy = "inline",
						opts = {
							index = 11,
							modes = { "v" },
							short_name = "refactor",
							auto_submit = true,
							user_prompt = false,
							stop_context_insertion = true,
						},
						prompts = {
							{
								role = "system",
								content = prompts.copilot_refactor,
								opts = {
									visible = false,
								},
							},
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(
										context.start_line,
										context.end_line
									)

									return "Please refactor the following code to improve its clarity and readability:\n\n```"
										.. context.filetype
										.. "\n"
										.. code
										.. "\n```\n\n"
								end,
								opts = {
									contains_code = true,
								},
							},
						},
					},
					["naming"] = {
						strategy = "inline",
						opts = {
							index = 12,
							modes = { "v" },
							short_name = "naming",
							auto_submit = true,
							user_prompt = false,
							stop_context_insertion = true,
						},
						prompts = {
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(
										context.start_line,
										context.end_line
									)

									return "Please provide better names for the following variables and functions:\n\n```"
										.. context.filetype
										.. "\n"
										.. code
										.. "\n```\n\n"
								end,
								opts = {
									contains_code = true,
								},
							},
						},
					},
				},
			})
		end,
	},
}
