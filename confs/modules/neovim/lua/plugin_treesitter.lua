declare_file("plugin:treesitter")

require("nvim-treesitter.configs").setup(
{
	ensure_installed =
	{
		-- languages
		"asm", "nasm", "disassembly", "linkerscript",
		"c", "printf", "make",
		"html", "css", "javascript",

		-- data format
		"toml", "json", "jsonc", "xml", "yaml",

		-- other
		"bash", "lua", "nix",
		"comment", "doxygen",
		"git_config", "git_rebase", "gitignore", "diff",
		"go", "dockerfile", "sql",
		"markdown", "markdown_inline",
		"passwd", "regex", "ssh_config",
	},

	sync_install = false,
	auto_install = true,

	highlight =
	{
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- vim.cmd("TSUpdateSync")
