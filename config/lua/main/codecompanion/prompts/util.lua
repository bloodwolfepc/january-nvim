local util = require("main.util")
local system = util.get_distro() or vim.loop.os_uname().sysname or "POSIX-compliant"
local language = vim.env.LANG or "en_US"
local nvim_version = string.format("%d.%d.%d", vim.version().major, vim.version().minor, vim.version().patch)
local date = os.date("%Y-%m-%d")

local prompts_dir = (vim.api.nvim_get_runtime_file("lua/main/codecompanion/prompts/", false))[1]
	or vim.notfily("Prompts directory not found", vim.log.levels.ERROR)
local get_prompt = function(prompt)
	return table.concat(vim.fn.readfile(prompts_dir .. prompt .. ".md"), "\n")
end
local get_prompt_no_md = function(prompt)
	return table.concat(vim.fn.readfile(prompts_dir .. prompt), "\n")
end

local context = string.format(
	[[
All non-code text responses must be written in the %s language.
The current date is %s.
The user's Neovim version is %s.
The user is working on a %s machine. Please respond with system specific commands if applicable.
]],
	language,
	date,
	nvim_version,
	system
)
return {
	context = "\n\n" .. "Additional context:" .. "\n\n" .. context,
	system = system,
	date = date,
	language = language,
	nvim_version = nvim_version,
	prompts_dir = prompts_dir,
	get_prompt = get_prompt,
	get_prompt_no_md = get_prompt_no_md,
}
