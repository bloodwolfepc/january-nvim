local M = {}

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

			--CASE 1: nested keymap table or override block
			if type(val) == "table" and not val[1] and not val.command then
				-- single override block
				if val.keys then
					walk(val.keys, {
						keyseq = keyseq,
						mode = merge_modes(ctx.mode, val.mode),
						builder = val.builder or ctx.builder,
					})
				else
					-- nested keymap table
					walk(val, {
						keyseq = keyseq,
						mode = ctx.mode,
						builder = ctx.builder,
					})
				end

			-- CASE 2: { command, opts } , override blocks
			elseif type(val) == "table" and val[1] then
				-- group of override blocks
				if val[1].keys then
					for _, val in pairs(val) do
						walk(val.keys, {
							keyseq = keyseq,
							mode = merge_modes(ctx.mode, val.mode),
							builder = val.builder or ctx.builder,
						})
					end

				-- value is { command, opts }
				else
					local command = val[1]
					local opts = val[2] or {}
					local passthrough = true

					-- check if passthough is disabled though opts
					if type(node) == "table" and opts.passthough == false then
						passthrough = false
					elseif passthrough and ctx.builder and ctx.builder.passthough then
						command = function()
							ctx.builder.passthough(val)
						end
					end

					table.insert(out, {
						keyseq = keyseq,
						command = command,
						desc = opts.desc or command,
						mode = ctx.mode,
					})
				end

			-- CASE 3: string command or function
			elseif type(val) == "string" or type(val) == "function" then
				local passthrough = true
				local command = val

				if passthrough and ctx.builder and ctx.builder.passthough then
					command = function()
						ctx.builder.passthough(val)
					end
				end

				--specify or imply description
				local desc
				if ctx.builder and ctx.builder.descmode == "specified" then
					desc = nil
				else
					desc = val
				end

				table.insert(out, {
					keyseq = keyseq,
					command = command,
					desc = desc or val,
					mode = ctx.mode,
				})
			end
		end
	end

	for _, val in ipairs(keymaps) do
		walk(val.keys, {
			keyseq = "",
			mode = val.mode,
			builder = val.builder,
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
		vim.keymap.set(val.mode, val.keyseq, val.command, { desc = val.desc })
	end
end

return M
