local state = require("lz.n.handler.state").new()

local M = {
	spec_field = "lsp",
}

function M.add(plugin)
	state.insert("lsp", plugin)
end

function M.del(name)
	state.del(name)
end

function M.lookup(name)
	return state.lookup_plugin(name)
end

local function resolve_filetypes(server_name, cfg)
	if cfg.filetypes then
		return cfg.filetypes
	end

	local ok, configs = pcall(require, "lspconfig.configs")
	if ok and configs[server_name] and configs[server_name].default_config then
		return configs[server_name].default_config.filetypes or {}
	end

	return {}
end

function M.apply()
	state.each_pending("lsp", function(plugin)
		local cfg = vim.deepcopy(plugin.lsp or {})
		cfg.filetypes = resolve_filetypes(plugin.name, cfg)

		vim.lsp.config(plugin.name, cfg)
		vim.lsp.enable(plugin.name)
	end)
end

return M
