declare_file("plugin:treesitter")

local ensure_installed_langs =
{
	-- languages
	"c", "make",
	"html", "css", "javascript", "typescript",

	-- data format
	"toml", "json", "jsonc", "yaml", "ini",

	-- other
	"bash", "lua", "nix",
	"comment", "regex",
	"dockerfile", "passwd",
	"git_config", "git_rebase", "gitignore", "diff",
	"markdown", "markdown_inline", "sql"
};

local using_configs, configs = pcall(require, "nvim-treesitter.configs")
local using_config, config = pcall(require, "nvim-treesitter.config")

if using_config and using_configs then
	print("treesitter: using both config and configs?, quitting...")
	return
end

-- New configuration
-- ------------------------------------------------------------

if not using_configs and not using_config
then
	print("treesitter: new configuration")
	local treesitter = require("nvim-treesitter")
	treesitter.setup()
	treesitter.install(ensure_installed_langs)
	vim.api.nvim_create_autocmd('FileType',
	{
		pattern = { ".*" },
		callback = function() vim.treesitter.start() end,
	})
	return
end

if not using_configs and using_config then
	print("treesitter: using config")
	configs = config
else
	print("treesitter: using configs")
end

require('nvim-treesitter.install').compilers = { "gcc" }
configs.setup(
{
	ensure_installed = ensure_installed_langs,

	sync_install = true,
	auto_install = true,

	highlight =
	{
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- vim.cmd("TSUpdateSync")
