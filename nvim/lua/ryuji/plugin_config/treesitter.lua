declare_plugin_config("treesitter")

-- avoid keeping to redownload files
vim.opt.runtimepath:append(SETTINGS.cache_path .. "/parsers")

-- use nixOS to find clangd
require("nvim-treesitter.install").compilers = {
	"/usr/bin/env clangd"
}

local treesitter = require_plugin("nvim-treesitter.configs")
treesitter.setup({
  ensure_installed = {
	  "lua", "c", "bash",
	  "astro", "html", "typescript", "javascript", "css",
	  "json", "hjson", "yaml",
	  "markdown", "markdown_inline",
	  "make", "gitignore", "dockerfile",
	  "nix", "vim", "query"
  },

  sync_install = false,
  auto_install = true,
  ignore_install = { },

  parser_install_dir = SETTINGS.cache_path .. "/parsers",

  highlight = {
    enable = true,

    disable = { },
    additional_vim_regex_highlighting = false,
  },
})

-- vim.cmd("TSUpdateSync")
