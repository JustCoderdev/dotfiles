declare_file("plugin:treesitter")

require("nvim-treesitter.configs").setup(
{
	ensure_installed =
	{
		-- languages
		"c", "make",
		"html", "css", "javascript", "typescript"

		-- data format
		"toml", "json", "jsonc", "yaml", "ini"

		-- other
		"bash", "lua", "nix",
		"comment", "regex",
		"dockerfile", "passwd",
		"git_config", "git_rebase", "gitignore", "diff",
		"markdown", "markdown_inline", "sql"
	},

	sync_install = true,
	auto_install = true,

	highlight =
	{
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- vim.cmd("TSUpdateSync")
