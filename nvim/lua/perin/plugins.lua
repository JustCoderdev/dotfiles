declare_file("plugins.lua")


--

local function require_packer()
	local packer_ok, packer = pcall(require, "packer")
	if(not packer_ok) then log_error(" /!\\  Error loading packer") return end

	return packer
end


-- AUTO INSTALL --

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"

	if fn.empty(fn.glob(install_path)) > 0 then
		log_error("Packer not found. Installing now...")

		fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
		vim.cmd [[packadd packer.nvim]]

		log("Packer installed, reload nvim")
		return true
	end

	return false
end

local packer_bootstrap = ensure_packer()


-- PLUGINS --

local packer = require_packer()
packer.startup({ function(use)
	use "wbthomason/packer.nvim"

	use "tpope/vim-surround"		-- Interact with bracket and quotes
	use "tpope/vim-commentary"		-- Handle comments

	-- use "junegunn/fzf"			-- Fuzzy finder
	-- use "nvim-pack/nvim-spectre"	-- Find and replace tool

	use "neovim/nvim-lspconfig"		-- Language server
	use {
		"hrsh7th/nvim-cmp",			-- Autocompletition engine
		requires = {
			{"hrsh7th/cmp-nvim-lsp"},
			{"hrsh7th/cmp-buffer"},
			{"hrsh7th/cmp-path"},
			{"hrsh7th/cmp-cmdline"},

			-- ultisnip
			-- {"SirVer/ultisnips"},
			-- {"quangnguyen30192/cmp-nvim-ultisnips"},

			-- luasnip
			-- {"L3MON4D3/LuaSnip"},
			-- {"saadparwaiz1/cmp_luasnip"},

			-- snippy
			-- {"dcampos/nvim-snippy"},
			-- {"dcampos/cmp-snippy"},

			-- vsnip
			{"hrsh7th/cmp-vsnip"},
			{"hrsh7th/vim-vsnip"},
			{"hrsh7th/vim-vsnip-integ"}
		}
	}

	use "folke/neodev.nvim"			-- Lua language extension
	use "p00f/clangd_extensions.nvim"	-- C language extension

	use "navarasu/onedark.nvim"			-- Colorscheme


	-- use { "ray-x/lsp_signature.nvim", commit = "1d96fac72eb6d74abd5b4d7883a01f58aeb4f87e" }
	-- use { "nvim-treesitter/nvim-treesitter", tag = "v0.8.1" }

	-- use "sbdchd/neoformat"

	-- use "nvim-lualine/lualine.nvim"
	-- use "ntpeters/vim-better-whitespace"
	-- use "windwp/nvim-autopairs"
	-- use "preservim/vimux"
	-- use "easymotion/vim-easymotion"
	-- use "mfussenegger/nvim-dap"
	-- use "simrat39/symbols-outline.nvim"
	-- use "RRethy/vim-illuminate"
	-- use "tommcdo/vim-lion"
	-- use "sindrets/diffview.nvim"
	-- use "honza/vim-snippets"

	-- Automatically set up configuration 
	if packer_bootstrap then packer.sync() end
end,
config = {
	display = {
		open_fn = require("packer.util").float
	}
}
})


-- AUTO UPDATE --

vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])


--

require_plugin_config("init")
