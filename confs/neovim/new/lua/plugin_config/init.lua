-- IMPORTANT: before lsp

require_plugin_config("neodev")
require_plugin_config("clangd_extensions")

-- require_plugin_config("lsp_signature")
require_plugin_config("nvim_cmp")

--
require_plugin_config("nvim_lspconfig")
--

-- require_plugin_config("onedark")
require_plugin_config("lualine") -- execute after onedark

-- require_plugin_config("formatter")

require_plugin_config("treesitter")	-- execute after nvim_lsp
require_plugin_config("nvim_autopairs")	-- execute after nvim_cmp

-- require_plugin_config("symbols_outline")
require_plugin_config("vim_illuminate")

-- require_plugin_config("ale")
require_plugin_config("fzf")



