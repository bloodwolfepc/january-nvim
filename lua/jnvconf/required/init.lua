local util = require("jnvconf.util")
local lz = require("lz.n")

lz.register_handler(require("lzextras.handlers.lsp"))
lz.register_handler(require("lzextras.handlers.conform"))
util.requireForModule("jnvconf.required", {
	"opts",
	"keymaps",
	"diagnostics",
})

require("theme").load()
