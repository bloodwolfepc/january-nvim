local opt = vim.opt
local g = vim.g
local cmd = vim.cmd
local fn = vim.fn

local globals = {
	mapleader = " ",
	maplocalleader = "<leader>l",
	netrw_banner = 0,
	netrw_mouse = 2,
	editorconfig = true,
	rust_recommended_style = false,
}

local options = {
	clipboard = "unnamedplus",
	termguicolors = true,
	backup = false,
	undofile = true,
	undodir = "/tmp/vim-undo",
	cmdheight = 1,
	conceallevel = 0,
	hlsearch = true,
	incsearch = true,
	ignorecase = true,
	breakindent = true,
	pumheight = 10,
	pumblend = 10,
	showmode = true,
	showtabline = 2,
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	timeoutlen = 300,
	updatetime = 50,
	writebackup = false,
	shiftwidth = 2,
	expandtab = true,
	tabstop = 2,
	softtabstop = 2,
	cursorline = false,
	number = true,
	laststatus = 3,
	showcmd = false,
	ruler = false,
	relativenumber = true,
	numberwidth = 4,
	signcolumn = "number",
	wrap = false,
	scrolloff = 999,
	--scrolloffpad = 1,
	sidescrolloff = 64,
	title = true,
	colorcolumn = "100",
	virtualedit = "block",
	inccommand = "split",
}
opt.shortmess:append("c")

cmd([[
  set iskeyword+=-
  set whichwrap+=<,>,[,],h,l
  colorscheme vim
]])

for global, value in pairs(globals) do
	g[global] = value
end
for option, value in pairs(options) do
	opt[option] = value
end
