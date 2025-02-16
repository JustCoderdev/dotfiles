declare_plugin_config("fzf")

local fzf = require_plugin('fzf-lua')
local actions = require "fzf-lua.actions"
fzf.setup({
	winopts = {
		border = "single",
		preview = {
			default     = 'builtin',           -- override the default previewer?
			border       = 'border', -- border|noborder, applies only to

			title_pos    = "left", -- left|center|right, title alignment
			scrollbar    = 'float', -- `false` or string:'float|border'
			-- float:  in-window floating border
			-- border: in-border chars (see below)
			scrolloff    = '-2', -- float scrollbar offset from right
			-- applies only when scrollbar = 'float'
			scrollchars  = { '█', '' }, -- scrollbar chars ({ <full>, <empty> }
			-- applies only when scrollbar = 'border'
			delay        = 250, -- delay(ms) displaying the preview
			-- prevents lag on fast scrolling
			winopts      = { -- builtin previewer window options
				number         = true,
				relativenumber = false,
				cursorline     = true,
				cursorlineopt  = 'both',
				cursorcolumn   = false,
				signcolumn     = 'no',
				list           = false,
				foldenable     = false,
				foldmethod     = 'manual',
			},
		},
	},
	keymap = {
		builtin = {
			["<C-d>"] = "preview-page-down",
			["<C-u>"] = "preview-page-up",
			-- ["<S-left>"] = "preview-page-reset",
		},
		fzf = {
			["ctrl-c"] = "abort",
			-- ["ctrl-b"] = "unix-line-discard",
			-- ["ctrl-d"] = "half-page-down",
			-- ["ctrl-u"] = "half-page-up",
			-- ["ctrl-g"] = "beginning-of-line",
			-- ["ctrl-g"] = "end-of-line",
			-- ["alt-a"]  = "toggle-all",
			["ctrl-d"]  = "preview-page-down",
			["ctrl-u"]  = "preview-page-up",
		},
	},
	actions = {
		files = {
			-- ["default"] = actions.file_edit_or_qf,
			-- ["ctrl-h"]  = actions.file_split,
			-- ["ctrl-v"]  = actions.file_vsplit,
			-- ["ctrl-t"]  = actions.file_tabedit,
			-- ["alt-q"]   = actions.file_sel_to_qf,
			-- ["alt-l"]   = actions.file_sel_to_ll,
		},
		buffers = {
			-- ["default"] = actions.buf_edit,
			-- ["ctrl-h"]  = actions.buf_split,
			-- ["ctrl-v"]  = actions.buf_vsplit,
			-- ["ctrl-t"]  = actions.buf_tabedit,
		}
	},
	symbols = {
		async_or_timeout = true, -- symbols are async by default
		symbol_style     = 1, -- style for document/workspace symbols

		symbol_icons     = {
			Key           = "ty",

			String        = "\"\"",
			Number        = "##",
			Boolean       = "01",
			Array         = "[]",
			Object        = "{}",
			Null          = "  ",

			Operator      = "+-",

			TypeParameter = "ty",
			Variable      = "xy",

			Constant      = "XY",

			Interface     = "  ",
			Module        = "  ",

			Struct        = "*{",
			Class         = "&{",

			Field         = ".x",
			Property      = ".x",

			Method        = "()",
			Function      = "()",
			Constructor   = "()",

			Enum          = "E.",
			EnumMember    = ".x",

			File          = "  ",
			Event         = "  ",

			Namespace     = "󰦮 ",
			Package       = " ",
		},
	}
})
