local Util = require("theme.util")

local M = {}

M.styles = setmetatable({}, {
	__index = function(_, style)
		local colors = vim.deepcopy(Util.mod("theme.colors." .. style))
		colors.none = "NONE"
		return colors
	end,
})

return M
