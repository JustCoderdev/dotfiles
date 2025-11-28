declare_file("plugin:fzf")

require('fzf-lua').setup(
{
	winopts = {
		border = "single",
		preview = {
			default   = "builtin", -- override default previewer
			border    = "border",  -- border|noborder
			title_pos = "left",    -- left|center|right, title alignment
			scrollbar = "border",  -- `false` or 'float|border'
			delay     = 250,       -- delay(ms) displaying the preview
			winopts   = {
				number         = true,
				relativenumber = false,
				cursorline     = true,
				cursorlineopt  = 'both',
				cursorcolumn   = false,
				signcolumn     = 'no',
				list           = false,
				foldenable     = false
			},
		},
	},
	keymap = {
		builtin = {
			["<C-d>"] = "preview-page-down",
			["<C-u>"] = "preview-page-up",
		},
		fzf = {
			["ctrl-c"] = "abort",
			-- ["ctrl-gg"] = "beginning-of-line",
			-- ["ctrl-g"] = "end-of-line",
			["ctrl-d"]  = "preview-page-down",
			["ctrl-u"]  = "preview-page-up",
		},
	}
})
