declare_plugin_config("neodev")

local neodev = require_plugin("neodev")

neodev.setup({
  library = {
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
	plugins = { "nvim-treesitter" },
  },
  setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
  lspconfig = true,
  pathStrict = true,
})
