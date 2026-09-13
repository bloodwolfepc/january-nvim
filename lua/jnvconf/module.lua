local M = {}

local cache

local function read_manifest()
	if cache ~= nil then
		return cache
	end

	local enabled = {}
	local manifest = vim.env.JNVIM_ENABLED_MODULES

	if manifest and manifest ~= "" then
		local ok_read, lines = pcall(vim.fn.readfile, manifest)
		if ok_read then
			local ok_decode, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
			if ok_decode and type(decoded) == "table" then
				enabled = decoded
			end
		end
	end

	cache = enabled
	return cache
end

local function is_excluded(name, exclude)
	if type(exclude) ~= "table" then
		return false
	end

	for _, item in ipairs(exclude) do
		if item == name then
			return true
		end
	end

	return false
end

local function normalize_module_name(name)
	return "jnvconf." .. name
end

function M.forModules(cb, opts)
	opts = opts or {}

	local modules = opts.modules or read_manifest()
	local submodules = opts.submodules
	local exclude = opts.exclude
	local file = opts.file or "init"

	for _, mod in ipairs(modules) do
		if type(mod) == "string" then
			local include = true

			if type(submodules) == "table" and #submodules > 0 then
				include = false
				for _, prefix in ipairs(submodules) do
					if mod == prefix or mod:match("^" .. vim.pesc(prefix) .. "%.") then
						include = true
						break
					end
				end
			end

			if include and not is_excluded(mod, exclude) then
				local req = normalize_module_name(mod)
				if file ~= "init" then
					req = req .. "." .. file
				end

				local ok, value = pcall(require, req)
				if ok then
					cb(value, mod)
				end
			end
		end
	end
end

return M
