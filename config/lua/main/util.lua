--if a tail is a string and nothing gived a disc, the desc will the the tail. if its a function and nothing can give a disc, it will just be :3
--lua annotations

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
			vim.print("PARSING:", val)
			local keyseq = ctx.keyseq .. key

			--CASE 1: nested keymap table or single override block
			if type(val) == "table" and not val[1] and not val.command then
				-- single override block
				if val.keys then
					walk(val.keys, {
						keyseq = keyseq,
						mode = merge_modes(ctx.mode, val.mode),
						builder = val.builder or ctx.builder,
					})

				--layerdesc
				elseif val == "layerdesc" then
					vim.keymap.set({ keyseq, keyseq, { desc = val } })

				-- nested keymap table
				else
					walk(val, {
						keyseq = keyseq,
						mode = ctx.mode,
						builder = ctx.builder,
					})
				end

			-- CASE 2: { command, opts } , group of override blocks, group of override block with layerdisc
			elseif type(val) == "table" and val[1] then
				vim.print("CMDOPTS")
				for _, val1 in ipairs(val) do
					-- group of override blocks
					if val1.keys then
						vim.print("HASKEYS")
						for _, val in pairs(val) do
							walk(val.keys, {
								keyseq = keyseq,
								mode = merge_modes(ctx.mode, val.mode),
								builder = val.builder or ctx.builder,
							})
						end

					-- layerdesc
					elseif val1 == "layerdesc" then
						vim.keymap.set({ keyseq, keyseq, { desc = val } })
						vim.print("LAYERDESC")
					else
						break
					end
				end

				-- value is { command, { opts } } or { command, command, ... { opts } }
				vim.print("RUNS ELSE")
				local command = val[1]
				local usebuilder = true
				local desc
				local opts = {}

				--find opts table if it exists
				for _, val1 in ipairs(val) do
					if type(val1) == "table" then
						opts = val1
					else
						vim.print("STRING:", val1)
					end
				end

				-- check if usebuilder is disabled though opts
				if type(node) == "table" and opts.usebuilder == false then
					usebuilder = false
				elseif usebuilder and ctx.builder then
					vim.print("BUILDER HAS VAL PASSED IN:", val)
					builder = function()
						ctx.builder(val)
					end
					vim.print("BUILDER HAS VAL PASSED IN FINAL:", val)
					-- I get attempt to call table here

					local builder1 = builder()
					vim.print("BUILDER HAS VAL PASSED IN FINALLL:", val)

					-- handle if builder returns a table with opts or a single function
					if type(builder1) == "function" then
						vim.print("CMD = BUILDER1:", val)
						command = builder1[1]
						--desc = builder[2].desc or desc
					else
						vim.print("CMD = BUILDER:", val)
						command = builder
					end
				end

				table.insert(out, {
					keyseq = keyseq,
					command = command,
					desc = opts.desc or desc,
					mode = ctx.mode,
				})

			-- CASE 3: single string command or function
			elseif type(val) == "string" or type(val) == "function" then
				local usebuilder = true
				local command = val
				local desc = ""
				local opts = {}

				if val == "layerdesc" then
					--vim.keymap.set({ mode, keyseq, { desc = val } })
					print("LAYERDESC")

				-- check if usebuilder is disabled though opts
				elseif type(node) == "table" and opts.usebuilder == false then
					usebuilder = false
				elseif usebuilder and ctx.builder then
					builder = function()
						ctx.builder(val)
					end

					-- handle if builder returns a table with opts or a single function
					if type(builder) == "table" and builder[1] then
						command = builder[1]
						desc = builder[2].desc or desc
					else
						command = builder
					end

					if desc == "" and type(val) == "string" then
						desc = val
					else
						desc = "xxx"
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
	vim.print(flattened_maps)
	for _, val in ipairs(flattened_maps) do
		vim.keymap.set(val.mode, val.keyseq, val.command, { desc = val.desc })
	end
end

return M
