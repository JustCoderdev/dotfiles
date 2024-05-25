declare_plugin_config("onedark")

local onedark = require_plugin("onedark")
onedark.setup {
	style = "darker",          -- Default theme style. Choose between "dark", "darker", "cool", "deep", "warm", "warmer" and "light"
	transparent = false,       -- Show/hide background

	term_colors = COLOR_CAPABLE, -- Change terminal color as per the selected theme style
	ending_tildes = true,      -- Show the end-of-buffer tildes. By default they are hidden
	cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

	-- toggle theme style ---
	toggle_style_key = nil,                                                           -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
	toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

	-- Change code style ---
	-- Options are italic, bold, underline, none
	-- You can configure multiple style with comma separated, For e.g., keywords = "italic,bold"
	code_style = {
		comments = "none",
		keywords = "bold",
		functions = "none",
		strings = "none",
		variables = "none"
	},

	-- Lualine options --
	lualine = {
		transparent = false, -- lualine center bar transparency
	},

	-- Custom Highlights --
	colors = {}, -- Override default colors
	highlights = {
		["@punctuation.special.markdown"] = { fg = '$red' },
		["@text.quote.markdown"]          = { fg = '$light_grey' },
		["@text.emphasis"]                = { fg = '$purple', fmt = 'italic' },
		["@text.strong"]                  = { fg = '$orange', fmt = 'bold' },
		["@text.strike"]                  = { fg = '$green', fmt = 'strikethrough,underline' },
		["@text.literal"]                 = { fg = '$red', fmt = "none" },
	}, -- Override highlight groups

	-- Plugins Config --
	diagnostics = {
		darker = true, -- darker colors for diagnostic
		undercurl = true, -- use undercurl instead of underline for diagnostics
		background = true, -- use background color for virtual text
	},
}
-- onedark.load()
