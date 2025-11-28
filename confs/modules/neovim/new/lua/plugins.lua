declare_file("plugins")

-- Future packet manager <https://neovim.io/doc/user/pack.html>


-- Bootstrapper
-- #----------------------------------------------------------# --

-- TODO: bootstrap
local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
if not is_installed then
	vim.fn.system { "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path }
end
vim.cmd.packadd("paq-nvim")
local paq = require("paq")

if not is_installed then
	vim.notify("Installing plugins. if prompted, hit Enter to continue.")
end

-- Package declaration
-- #----------------------------------------------------------# --

paq {
	{ "savq/paq-nvim", build = ":PaqSync" },
	
	
	-- lsp extensions
	-- #------------------# --

	"p00f/clangd_extensions.nvim", -- C language extension

	
	-- completition
	-- #------------------# --
	
	-- vsnip
	"hrsh7th/cmp-vsnip", -- Autocompletition engine
	"hrsh7th/vim-vsnip",
	"hrsh7th/vim-vsnip-integ",

	-- nvim-cmp
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",

	-- #------------------# --
	
	"neovim/nvim-lspconfig", -- Language server

	-- #------------------# --
	
	"ellisonleao/gruvbox.nvim",
	"nvim-lualine/lualine.nvim", -- Better status bar

	-- "nvim-treesitter/nvim-treesitter", -- Display syntax highlighting
	-- "ntpeters/vim-better-whitespace"   -- Check for trailing whitespaces
	-- "tommcdo/vim-lion"                 -- Provide indentation for code blocks
	-- "dense-analysis/ale"               -- Static code analisys
	
	-- "junegunn/fzf", run = ":call fzf#install()" },
	-- "ibhagwan/fzf-lua", -- Fuzzy finder

	-- "norcalli/nvim-colorizer.lua", run = ":lua require'colorizer'.setup({ '!*'; })" }


}

paq.install()

if is_installed then
	require_file("plugin_nvim_cmp")
	require_file("plugin_lsp")
	require_file("plugin_gruvbox")
	require_file("plugin_lualine")
end
