local M = {}

function M.get(c, opts)
	return {
		Comment = { fg = c.comment },
		-- ColorColumn = { c.

		Pmenu = { fg = c.fg, bg = c.none },
		PmenuMatch = { fg = c.fg, bg = c.none },
		PmenuSel = { fg = c.fg, bg = c.none },
		PmenuMatchSel = { fg = c.fg, bg = c.none },
		PmenuSbar = { fg = c.fg, bg = c.none },
		PmenuThumb = { fg = c.fg, bg = c.none },

		ibl1 = { fg = c.g1, nocombine = true },
		ibl2 = { fg = c.g2, nocombine = true },
		ibl3 = { fg = c.g3, nocombine = true },
		ibl4 = { fg = c.g4, nocombine = true },
		ibl5 = { fg = c.g5, nocombine = true },
		ibl6 = { fg = c.g6, nocombine = true },
		IblScope = { fg = c.cyan, nocombine = true },

		CmpNormal = { fg = "#ffffff", bg = "#000000" },

		BlinkCmpDoc = { fg = c.fg, bg = c.bg_float },
		BlinkCmpDocBorder = { fg = c.border_highlight, bg = c.bg_float },
		BlinkCmpGhostText = { fg = c.terminal_black },
		BlinkCmpKindCodeium = { fg = c.teal, bg = c.none },
		BlinkCmpKindCopilot = { fg = c.teal, bg = c.none },
		BlinkCmpKindDefault = { fg = c.fg_dark, bg = c.none },
		BlinkCmpKindSupermaven = { fg = c.teal, bg = c.none },
		BlinkCmpKindTabNine = { fg = c.teal, bg = c.none },
		BlinkCmpLabel = { fg = c.white, bg = c.none },
		BlinkCmpLabelDeprecated = { fg = c.fg_gutter, bg = c.none, strikethrough = true },
		BlinkCmpLabelMatch = { fg = c.cyan, bg = c.none, underline = true },
		BlinkCmpMenu = { fg = c.fg, bg = c.none },
		BlinkCmpMenuSelection = { fg = c.none, bg = c.purple },
		BlinkCmpMenuBorder = { fg = c.border_highlight, bg = c.bg_float },
		BlinkCmpSignatureHelp = { fg = c.fg, bg = c.bg_float },
		BlinkCmpSignatureHelpBorder = { fg = c.border_highlight, bg = c.bg_float },
		BlinkCmpScrollBarThumb = { fg = c.fg, bg = c.none },
		BlinkCmpScrollBarGutter = { fg = c.none, bg = c.none },

		-- SpellBad = { fg = c.none, bg = c.none, sp = c.none, undercurl = true },
		-- SpellCap = { fg = c.none, bg = c.none, sp = c.none, undercurl = true },
		-- SpellRare = { fg = c.purple, bg = c.none, sp = c.purple, undercurl = true },
		-- SpellLocal = { fg = c.purple, bg = c.none, sp = c.purple, undercurl = true },

		WhichKeyFloat = { fg = c.g6, bg = c.none },
		WhichKey = { fg = c.g6, bg = c.none },
		WhichKeyBorder = { fg = c.g4, bg = c.none },
		WhichKeyNormal = { fg = c.g4, bg = c.none },

		AvanteTitle = { fg = c.fg, bg = c.none },
		AvanteReversedTitle = { fg = c.fg, bg = c.none },
		AvanteSubtitle = { fg = c.fg, bg = c.none },
		AvanteReversedSubtitle = { fg = c.fg, bg = c.none },
		AvanteThirdTitle = { fg = c.fg, bg = c.none },
		AvanteReversedThirdTitle = { fg = c.fg, bg = c.none },
		AvantePromptInput = { fg = c.fg, bg = c.none },
		AvantePromptInputBorder = { fg = c.fg, bg = c.none },
	}
end

return M
