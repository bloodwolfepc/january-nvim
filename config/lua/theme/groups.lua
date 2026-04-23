local M = {}

function M.get(c, opts)
	return {
		ibl1 = { fg = c.g1, nocombine = true },
		ibl2 = { fg = c.g2, nocombine = true },
		ibl3 = { fg = c.g3, nocombine = true },
		ibl4 = { fg = c.g4, nocombine = true },
		ibl5 = { fg = c.g5, nocombine = true },
		ibl6 = { fg = c.g6, nocombine = true },
		IblScope = { fg = c.cyan, nocombine = true },
	}
end

return M
