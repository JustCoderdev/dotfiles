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

-- IMPORTANT: before lsp
	use "folke/neodev.nvim"					-- Lua language extension
	use "p00f/clangd_extensions.nvim"		-- C language extension

	use {									-- Display function definition
		"ray-x/lsp_signature.nvim",
		commit = "1d96fac72eb6d74abd5b4d7883a01f58aeb4f87e"
	}

	use {								-- Autocompletition engine
		"hrsh7th/nvim-cmp",
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

--
	use "neovim/nvim-lspconfig"			-- Language server
--

	use "tpope/vim-surround"			-- Interact with bracket and quotes
	use "tpope/vim-commentary"			-- Handle comments

	use "navarasu/onedark.nvim"				-- Colorscheme
	use "sbdchd/neoformat"					-- Format file
	use "nvim-lualine/lualine.nvim"			-- Prettify line below

	use {									-- Display syntax highlighting
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.8.1"
	}

	use "ntpeters/vim-better-whitespace"	-- Check for trailing whitespaces
	use "windwp/nvim-autopairs"				-- Automatically add closing bracket
	use "simrat39/symbols-outline.nvim"		-- Provide an outline for current file

	use "RRethy/vim-illuminate"				-- Highlight word under cursor
	use "tommcdo/vim-lion"					-- Provide indentation for code blocks

	-- use "sindrets/diffview.nvim"			-- Better diff-views
	-- use "honza/vim-snippets"				-- More snippets

	-- use "junegunn/fzf"					-- Fuzzy finder
	-- use "nvim-pack/nvim-spectre"			-- Find and replace tool

	-- use "preservim/vimux"				-- Interact with tmux seamlessly
	-- use "easymotion/vim-easymotion"		-- Customise number in keybinding
	-- use "mfussenegger/nvim-dap"			-- Debug Adapter Protocol support

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

-- vim.cmd([[
-- augroup packer_user_config
-- autocmd!
-- autocmd BufWritePost plugins.lua source <afile> | PackerSync
-- augroup end
-- ]])


--

require_plugin_config("init")
