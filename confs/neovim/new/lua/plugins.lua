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
	vim.notify("Installing plugins... If prompted, hit Enter to continue.")
end


-- Package declaration
-- #----------------------------------------------------------# --

paq {
	{ "savq/paq-nvim", build = ":PaqSync" },
	-- #------------------# --
	"p00f/clangd_extensions.nvim" -- C language extension

	-- "neovim/nvim-lspconfig",
}

paq.install()
