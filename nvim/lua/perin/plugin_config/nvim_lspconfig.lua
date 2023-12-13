declare_plugin_config("nvim_lspconfig")

-- Need to be called after plugins:
-- 	  - language extensions
-- 	  - nvim_cmp
-- 	  - lsp_signature

local lspconfig = require_plugin("lspconfig")


-- LANGUAGE SUPPORT --
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Web
-- vim.g.markdown_fenced_languages = { "ts=typescript" } -- for deno

-- lspconfig.astro.setup { 		capabilities = capabilities }
-- lspconfig.denols.setup {		capabilities = capabilities }
-- lspconfig.tsserver.setup {	capabilities = capabilities }
-- lspconfig.html.setup { 		capabilities = capabilities }
-- lspconfig.cssls.setup { 		capabilities = capabilities }
-- lspconfig.jsonls.setup {		capabilities = capabilities }
-- lspconfig.eslint.setup {		capabilities = capabilities }

-- Tools
lspconfig.dockerls.setup { capabilities = capabilities }
-- lspconfig.docker_compose_language_service.setup { capabilities = capabilities }}

-- Random
local c_capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
c_capabilities.textDocument.completion.completionItem.snippetSupport = true
c_capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}
lspconfig.clangd.setup {
	on_attach = function(client, bufnr)
		require("clangd_extensions.inlay_hints").setup_autocmd()
		require("clangd_extensions.inlay_hints").set_inlay_hints()
	end,
	cmd = {
		"/usr/bin/clangd",
		"--background-index",
		"--pch-storage=memory",
		"--all-scopes-completion",
		"--pretty",
		"--header-insertion=never",
		"-j=4",
		"--inlay-hints",
		"--header-insertion-decorators",
		"--function-arg-placeholders",
		"--completion-style=detailed",
		-- custom
		-- "-xc",
		-- "-Wall",
		-- "-Wextra",
		-- "-Werror",
		-- "-Wpedantic",
		-- "-pedantic",
		-- "-pedantic-errors",
		-- "-std=c89",
		-- "-fcolor-diagnostics"
	},
	filetypes = { "c" }, -- "cpp", "objc", "objcpp"
	-- root_dir = lspconfig.util.root_pattern("src"),
	init_option = { fallbackFlags = {  "-std=c89"  } },
	capabilities = c_capabilities
}


lspconfig.bashls.setup{}
lspconfig.lua_ls.setup{
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
			client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {

				Lua = {
					diagnostics = {
						globals = { 'vim' }
					},
					runtime = {
						version = 'LuaJIT'
					},
					workspace = {
						library = {
							[vim.fn.expand('$VIMRUNTIME/lua')] = true,
							[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
						}
					},
				}
			})

			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
		return true
	end,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace"
			}
		}
	}
}


-- KEYMAPS --

-- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "nd", vim.diagnostic.goto_next)
vim.keymap.set("n", "Nd", vim.diagnostic.goto_prev)
-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
	-- attach lsp_signature
	require("lsp_signature").on_attach()

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set("n", "<space>wl", function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    vim.keymap.set("n", "<Leader>d", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)
    -- vim.keymap.set({"n","v"}, "<Leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<Leader>f", function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
