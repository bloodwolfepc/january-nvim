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

			--CASE 1: nested keymap table or single override block
			if type(val) == "table" and not val[1] and not val.command then
				-- single override block
				if val.keys then
					walk(val.keys, {
						keyseq = keyseq,
						mode = merge_modes(ctx.mode, val.mode),
						builder = val.builder or ctx.builder,
						desc = val.builder or ctx.desc,
					})

				--layerdesc
				elseif val.layerdesc then
					--vim.keymap.set({ keyseq, keyseq, { desc = val } })

					-- nested keymap table
				else
					walk(val, {
						keyseq = keyseq,
						mode = ctx.mode,
						builder = ctx.builder,
						desc = ctx.desc,
					})
				end

			-- CASE 2: { command, opts } , group of override blocks, group of override block with layerdisc
			elseif type(val) == "table" and val[1] then
				--layerdesc
				if val.layerdesc then
					vim.keymap.set(table.concat(ctx.mode, ", "), keyseq, "", { desc = val.layerdesc })
				end

				for _, val1 in ipairs(val) do
					-- group of override blocks
					if val1.keys then
						walk(val1.keys, {
							keyseq = keyseq,
							mode = merge_modes(ctx.mode, val.mode),
							builder = val.builder or ctx.builder,
							desc = val.desc or ctx.desc,
						})

					-- value is { command, { opts } } or { command, command, ... { opts } }
					else
						local command = val[1]
						local usebuilder = true
						local desc
						local opts = {}

						--find opts table if it exists
						for _, val1 in ipairs(val) do
							if type(val1) == "table" then
								opts = val1
							end
						end

						-- check if usebuilder is disabled though opts
						if type(node) == "table" and opts.usebuilder == false then
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

						table.insert(out, {
							keyseq = keyseq,
							command = command,
							desc = opts.desc or desc,
							mode = ctx.mode,
						})
					end
				end

			-- CASE 3: single string command or function
			elseif type(val) == "string" or type(val) == "function" then
				local usebuilder = true
				local command = val
				local desc = ""
				local opts = {}

				if val == "layerdesc" then
					--vim.keymap.set({ mode, keyseq, { desc = val } })

					-- check if usebuilder is disabled though opts
				elseif type(node) == "table" and opts.usebuilder == false then
					usebuilder = false
				elseif usebuilder and ctx.builder then
					command = function()
						ctx.builder(val)
					end

					--check for desc function
					if type(ctx.desc) == "function" then
						desc = ctx.desc(val)
					else
						desc = desc
					end

					table.insert(out, {
						keyseq = keyseq,
						command = command,
						desc = desc,
						mode = ctx.mode,
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
