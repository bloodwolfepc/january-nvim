local util = require("jnvconf.util")

util.requireForModule("jnvconf.required", {
	"opts",
	"keymaps",
	"diagnostics",
})

require("theme").load()
