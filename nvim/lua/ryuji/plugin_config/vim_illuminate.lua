declare_plugin_config("vim_illuminate")

local illuminate = require_plugin("illuminate")
illuminate.configure({
	-- providers: provider used to get references in the buffer, ordered by priority
	providers = { 'lsp', 'treesitter', 'regex', },

	-- delay: delay in milliseconds
	delay = 100,

	-- filetype_overrides: filetype specific overrides.
	-- The keys are strings to represent the filetype while the values are tables that
	filetype_overrides = {},

	-- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
	filetypes_denylist = { 'dirbuf', 'dirvish', 'fugitive', },

	-- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
	filetypes_allowlist = {},

	-- modes_denylist: modes to not illuminate, this overrides modes_allowlist
	modes_denylist = {},

	-- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
	modes_allowlist = {},

	-- under_cursor: whether or not to illuminate under the cursor
	under_cursor = true,

	-- large_file_cutoff: number of lines at which to use large_file_config
	large_file_cutoff = nil,

	-- large_file_config: config to use for large files (based on large_file_cutoff).
	large_file_overrides = nil,

	-- min_count_to_highlight: minimum number of matches required to perform highlighting
	min_count_to_highlight = 2,
	-- should_enable: a callback that overrides all other settings to

	should_enable = function(bufnr) return true end,

	-- case_insensitive_regex: sets regex case sensitivity
	case_insensitive_regex = false,
})
