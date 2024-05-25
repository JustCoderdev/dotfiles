declare_plugin_config("treesitter")

-- avoid keeping to redownload files
vim.opt.runtimepath:append(SETTINGS.cache_path .. "/parsers")

-- use nixOS to find clang
--require("nvim-treesitter.install").compilers = { "clang" }

local treesitter = require_plugin("nvim-treesitter.configs")
treesitter.setup({
	ensure_installed = {
		"lua", "c", "bash",
		"html", "typescript", "javascript", "css",
		"json", -- "yaml",
		"markdown", "markdown_inline",
		"make", "gitignore", "dockerfile",
		"nix", "vim", "query"
	},

	sync_install = false,
	auto_install = true,
	ignore_install = {},

	parser_install_dir = SETTINGS.cache_path .. "/parsers",

	highlight = {
		enable = true,

		disable = {},
		additional_vim_regex_highlighting = false,
	},
})

-- vim.cmd("TSUpdateSync")
