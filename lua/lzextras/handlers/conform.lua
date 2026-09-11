local state = require("lz.n.handler.state").new()

local M = {
	spec_field = "conform",
}

function M.add(plugin)
	state.insert("conform", plugin)
end

function M.del(name)
	state.del(name)
end

function M.lookup(name)
	return state.lookup_plugin(name)
end

local function merge_conform_opts(dst, src)
	for k, v in pairs(src) do
		if k == "formatters_by_ft" and type(v) == "table" then
			dst.formatters_by_ft = dst.formatters_by_ft or {}
			for ft, ft_cfg in pairs(v) do
				dst.formatters_by_ft[ft] = ft_cfg
			end
		elseif type(v) == "table" and type(dst[k]) == "table" then
			dst[k] = vim.tbl_deep_extend("force", dst[k], v)
		else
			dst[k] = v
		end
	end
end

function M.apply()
	local opts = {}

	state.each_pending("conform", function(plugin)
		merge_conform_opts(opts, plugin.conform or {})
	end)

	require("conform").setup(opts)
end

return M
