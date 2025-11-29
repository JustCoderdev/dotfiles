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

	"ellisonleao/gruvbox.nvim",  -- Theme
	"nvim-lualine/lualine.nvim", -- Better status bar

	"nvim-treesitter/nvim-treesitter", -- Display syntax highlighting
	"ntpeters/vim-better-whitespace",  -- Check for trailing whitespaces
	"tommcdo/vim-lion",                -- Provide indentation
	"dense-analysis/ale",              -- Static code analisys

	"junegunn/fzf",                    -- Fuzzy finder
	"ibhagwan/fzf-lua",

	"norcalli/nvim-colorizer.lua"      -- Color colorcodes #604010
	"RRethy/vim-illuminate.git"        -- Higlight hovered symbol
}

paq.install()


-- Plugin configurations
-- #----------------------------------------------------------# --

if is_installed then
	require_file("plugin_nvim_cmp")
	require_file("plugin_lsp")
	require_file("plugin_gruvbox")
	require_file("plugin_lualine")
	require_file("plugin_treesitter")
	require_file("plugin_fzf")

	-- vim-better-whitespace
	vim.cmd("hi ExtraWhitespace ctermbg=red ctermfg=gray")

	-- ale
	vim.cmd("let g:ale_c_cc_options = '-std=c89 -ansi -pedantic-errors -pedantic -Wall -Wextra -Werror -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wstrict-prototypes -Wmissing-prototypes -Wconversion -g -Wno-unused-variable -Wfatal-errors'")

	-- colorizer rgb(80, 32, 32) #205020
	require("colorizer").setup({'*';}, { rgb_fn = true; hsl_fn = true; })

	-- vim-illuminate onedark-darker-bg1
	vim.cmd("hi IlluminatedWordText  guibg=#30363f gui=NONE")
	vim.cmd("hi IlluminatedWordRead  guibg=#30363f gui=NONE")
	vim.cmd("hi IlluminatedWordWrite guibg=#30363f gui=NONE")
end

