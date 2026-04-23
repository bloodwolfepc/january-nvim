local colors_mod = require("theme.colors")
local groups = require("theme.groups")

local M = {}

---@param opts? table
function M.load(opts)
	opts = opts or {}

	local style = opts.style or "default"
	local colors = colors_mod.styles[style]

	local highlights = groups.get(colors, opts)
	for group, spec in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, spec)
	end

	vim.g.colors_name = "theme"
end

return M
