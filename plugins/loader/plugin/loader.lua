local enabled = { "required" }

local cfg = vim.env.JNVIM_CONFIG_PATH
if cfg and cfg ~= "" then
	vim.opt.runtimepath:prepend(cfg)
	package.path = cfg .. "/lua/?.lua;" .. cfg .. "/lua/?/init.lua;" .. package.path
end

local manifest = vim.env.JNVIM_ENABLED_MODULES
if manifest and manifest ~= "" then
	local ok_read, lines = pcall(vim.fn.readfile, manifest)
	if ok_read then
		local ok_decode, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
		if ok_decode and type(decoded) == "table" and #decoded > 0 then
			enabled = decoded
		end
	end
end

for _, mod in ipairs(enabled) do
	local ok_mod, err = pcall(require, "jnvconf." .. mod)
	if not ok_mod then
		vim.notify("failed to load jnvconf." .. mod .. ": " .. err, vim.log.levels.WARN)
	end
end
