local M = {}

local function merge(dst, src)
	for k, v in pairs(src) do
		dst[k] = v
	end
	return dst
end

M.addPacks = function(name, plugins)
	local result = { name }
	if plugins then
		for _, v in ipairs(plugins) do
			table.insert(result, v)
		end
	end
	for _, v in ipairs(result) do
		vim.cmd.packadd(v)
	end
end

local function parseKeymaps(keymaps)
	local out = {}

	local function merge_modes(a, b)
		if not b then
			return a
		end
		return b
	end

	local function walk(node, ctx)
		for key, val in pairs(node) do
			local keyseq = ctx.keyseq .. key

			--CASE 1: nested keymap table, single override block, layerdesc
			if type(val) == "table" and not val[1] and not val.command then
				if val.keys or val.mode or val.builder then
					error("Single override blocks are not supported, assert as such { { overridesA }, { overridesB } }")

				-- nested keymap table
				else
					walk(val, {
						keyseq = keyseq,
						mode = ctx.mode,
						builder = ctx.builder,
						desc = ctx.desc,
						opts = ctx.opts,
					})
				end

			-- CASE 2: { command, { opts } } , group of override blocks, layerdisc
			elseif type(val) == "table" and val[1] then
				-- { command, { opts } }
				if type(val[1]) == "function" or type(val[1]) == "string" then
					local command = val[1]
					local usebuilder = true
					local desc
					local opts = {}

					-- check if usebuilder is disabled though opts
					if type(node) == "table" and opts.usebuilder == false or type(val[1]) == "function" then
						usebuilder = false
					elseif usebuilder and ctx.builder then
						command = function()
							ctx.builder(val)
						end
					end

					--check for desc function
					if type(ctx.desc) == "function" then
						desc = ctx.desc(val)
					else
						desc = desc
					end

					--find opts table if it exists
					for _, val1 in ipairs(val) do
						if type(val1) == "table" then
							opts = val1
						end
					end

					if opts.desc then
						desc = opts.desc
					end

					table.insert(out, {
						keyseq = keyseq,
						command = command,
						desc = opts.desc or desc,
						mode = ctx.mode,
						opts = ctx.opts,
					})

				-- group of override blocks
				else
					for _, val1 in ipairs(val) do
						-- group of override blocks
						if val1.keys then
							walk(val1.keys, {
								keyseq = keyseq,
								mode = merge_modes(ctx.mode, val1.mode),
								builder = val1.builder or ctx.builder,
								desc = val1.desc or ctx.desc,
								opts = val1.opts or ctx.opts,
							})
						end
					end
				end

			-- CASE 3: single string command or function
			elseif type(val) == "string" or type(val) == "function" then
				local command = val
				local desc = ""
				local opts = {}
				local layerdesc

				--layerdesc
				if key == "layerdesc" and type(val) == "string" then
					layerdesc = val
				end

				-- check if usebuilder is disabled though opts
				if ctx.builder and type(ctx.builder) == "function" then
					command = function()
						ctx.builder(val)
					end
				end

				--check for desc function
				if type(ctx.desc) == "function" then
					desc = ctx.desc(val)
				else
					desc = desc
				end

				if type(layerdesc) == "string" then
					local keyseq1 = string.gsub(keyseq, "layerdesc", "")
					vim.keymap.set(ctx.mode, keyseq1, "", { desc = layerdesc })
				elseif type(layerdesc) ~= "string" then
					table.insert(out, {
						keyseq = keyseq,
						command = command,
						desc = desc,
						mode = ctx.mode,
						opts = ctx.opts or opts,
					})
				end
			end
		end
	end

	for _, val in ipairs(keymaps) do
		walk(val.keys, {
			keyseq = "",
			mode = val.mode,
			builder = val.builder,
			desc = val.desc,
			opts = val.opts,
		})
	end
	return out
end

M.keymapsForLzn = function(keymaps)
	local flattened_maps = parseKeymaps(keymaps)
	local result = {}
	for _, val in ipairs(flattened_maps) do
		table.insert(result, {
			val.keyseq,
			val.command,
			desc = val.desc,
			mode = val.mode,
		})
	end
	return result
end

M.lznWrapper = function(config, keymaps)
	local keymap = require("lz.n").keymap(config)
	local flattened_maps = parseKeymaps(keymaps)
	for _, val in ipairs(flattened_maps) do
		keymap.set(val.modes, val.keyseq, val.command, { desc = val.desc })
	end
end

M.keymapsForVim = function(keymaps)
	local flattened_maps = parseKeymaps(keymaps)

	for _, val in ipairs(flattened_maps) do
		local opts = {}
		if val.opts ~= nil then
			opts = merge(merge(opts, { desc = val.desc }), val.opts)
		else
			opts = { desc = val.desc }
		end
		vim.keymap.set(val.mode, val.keyseq, val.command, opts)
	end
end

return M
