dofile(assert(vim.env.JNVIM_CONFIG_PATH) .. "/lua/jnvconf/required/opts.lua")

local expected = {
	"n-v-c-sm:block",
	"i-ci-ve:ver25",
	"r-cr-o:hor20",
	"a:blinkwait700-blinkon500-blinkoff500",
}
assert(vim.deep_equal(vim.opt.guicursor:get(), expected), "Cursor shape or blink policy changed")
print("Cursor shapes and all-mode blinking validated")
