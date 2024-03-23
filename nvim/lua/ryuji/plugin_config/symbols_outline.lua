declare_plugin_config("symbols_outline")

local sout = require_plugin("symbols-outline")
sout.setup({
	highlight_hovered_item = true,
	show_guides = true,
	auto_preview = true,
	position = 'right',
	relative_width = true,
	width = 25,
	auto_close = false,
	show_numbers = false,
	show_relative_numbers = false,
	show_symbol_details = true,
	preview_bg_highlight = 'Pmenu',
	autofold_depth = nil,
	auto_unfold_hover = true,
	fold_markers = { '', '' },
	wrap = false,
	keymaps = { -- These keymaps can be a string or a table for multiple keys
		close = { "<Esc>", "q" },
		goto_location = "<Cr>",
		focus_location = "o",
		hover_symbol = "<C-space>",
		toggle_preview = "K",
		rename_symbol = "r",
		code_actions = "a",
		fold = "h",
		unfold = "l",
		fold_all = "W",
		unfold_all = "E",
		fold_reset = "R",
	},
	lsp_blacklist = {},
	symbol_blacklist = {},
	symbols = {
		Operator      = { icon = "+-", hl = "@operator" },

		Key           = { icon = "ty", hl = "@type" },
		TypeParameter = { icon = "ty", hl = "@parameter" },
		Variable      = { icon = "xy", hl = "@constant" },

		Constant      = { icon = "XY", hl = "@constant" },

		String        = { icon = "\"\"", hl = "@string" },
		Number        = { icon = "##", hl = "@number" },
		Boolean       = { icon = "01", hl = "@boolean" },
		Array         = { icon = "[]", hl = "@constant" },
		Object        = { icon = "{}", hl = "@type" },
		Null          = { icon = "  ", hl = "@type" },

		Interface     = { icon = "  ", hl = "@type" },
		Module        = { icon = " ", hl = "@namespace" },

		Struct        = { icon = "*{", hl = "@type" },
		Class         = { icon = "&{", hl = "@type" },

		Field         = { icon = ".x", hl = "@field" },
		Property      = { icon = ".x", hl = "@method" },

		Method        = { icon = "()", hl = "@method" },
		Function      = { icon = "()", hl = "@function" },
		Constructor   = { icon = "()", hl = "@constructor" },

		Enum          = { icon = "E.", hl = "@type" },
		EnumMember    = { icon = ".x", hl = "@field" },

		File          = { icon = " ", hl = "@text.uri" },
		Event         = { icon = " 🗲", hl = "@type" },

		Namespace     = { icon = " ", hl = "@namespace" },
		Package       = { icon = " ", hl = "@namespace" },
		Component     = { icon = " ", hl = "@function" },
		Fragment      = { icon = " ", hl = "@constant" },
	},
})
