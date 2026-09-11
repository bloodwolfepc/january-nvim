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

function M.group(prefix)
	local out = {}
	local pattern = "^" .. vim.pesc(prefix) .. "%."

	for _, mod in ipairs(read_manifest()) do
		if type(mod) == "string" and mod:match(pattern) then
			out[#out + 1] = mod
		end
	end

	return out
end

function M.require_group(prefix)
	local out = {}

	for _, mod in ipairs(M.group(prefix)) do
		local ok, value = pcall(require, "jnvconf." .. mod)
		if ok and type(value) == "table" then
			out[#out + 1] = value
		end
	end

	return out
end

function M.langs()
	return M.require_group("langs")
end

function M.forLang(fn)
	for _, lang in ipairs(M.langs()) do
		fn(lang)
	end
end

return M
