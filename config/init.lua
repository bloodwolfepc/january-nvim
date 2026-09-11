vim.opt.runtimepath:prepend(vim.env.JNVIM_CONFIG_PATH or "")
package.path = (vim.env.JNVIM_CONFIG_PATH or "")
	.. "/lua/?.lua;"
	.. (vim.env.JNVIM_CONFIG_PATH or "")
	.. "/lua/?/init.lua;"
	.. package.path
require("jnvconf.loader")
