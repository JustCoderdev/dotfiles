declare_file("plugin:fzf")

require('fzf-lua').setup(
{
	files = {
		path_shorten = false,
		cwd = vim.fn.getcwd(),
	},
	grep = {
		cwd = vim.fn.getcwd(),
	},
	winopts =
	{
		border = "single",
		preview =
		{
			default = "builtin", -- override default previewer
			border = "border",  -- border|noborder

			title = false,
			scrollbar = "border",  -- `false` or 'float|border'
			delay = 250,       -- delay(ms) displaying the preview

			winopts = {
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
