declare_plugin_config("nvim_lspconfig")
-- Open logs:
-- :lua vim.cmd('e'..vim.lsp.get_log_path())

-- Need to be called after plugins:
-- 	  - language extensions
-- 	  - nvim_cmp
-- 	  - lsp_signature

local lspconfig = require_plugin("lspconfig")


-- LANGUAGE SUPPORT --
local snip_cap = require('cmp_nvim_lsp').default_capabilities()
snip_cap.textDocument.completion.completionItem.snippetSupport = true

-- Web
-- vim.g.markdown_fenced_languages = { "ts=typescript" } -- for deno

-- lspconfig.astro.setup { capabilities = snip_cap } -- npm install -g @astrojs/language-server
-- lspconfig.denols.setup { capabilities = snip_cap }
-- lspconfig.tsserver.setup { capabilities = snip_cap }

 -- npm i -g vscode-langservers-extracted
lspconfig.html.setup { capabilities = snip_cap }
lspconfig.cssls.setup { capabilities = snip_cap }
lspconfig.jsonls.setup { capabilities = snip_cap }
lspconfig.eslint.setup { capabilities = snip_cap }

-- npm i -g css-variables-language-server
lspconfig.css_variables.setup { capabilities = snip_cap }

-- Tools
lspconfig.nixd.setup { capabilities = snip_cap }
lspconfig.marksman.setup { capabilities = snip_cap }
lspconfig.dockerls.setup { capabilities = snip_cap }
lspconfig.docker_compose_language_service.setup { capabilities = snip_cap }
-- lspconfig.arduino_language_server.setup {} -- go install github.com/arduino/arduino-language-server@latest

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
		-- NixOS Shenanigans
		"/usr/bin/env",
		"clangd",

		-- CLANGD args
		--"/usr/bin/clangd",
		"-pch-storage=memory",
		"-pretty",
		"-j=4",
		"-header-insertion-decorators",
		"-completion-style=detailed",
		-- "-compile-commands-dir=/home/ryuji/.config/clangd"

		-- NOT AVAILABLE IN version 7.0.1-8
		"--function-arg-placeholders",
		"--background-index",
		"--all-scopes-completion",
		"--header-insertion=never",
		"--inlay-hints",

		-- CLANG args
		-- "/usr/bin/clang",
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
	filetypes = { "c", "cpp" }, --  "objc", "objcpp"
	root_dir = lspconfig.util.root_pattern("src"),
	-- init_option = {
	-- 	fallbackFlags = { "-std=c89" },
	-- },
	capabilities = c_capabilities
}


lspconfig.bashls.setup {}
lspconfig.lua_ls.setup {
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
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
vim.keymap.set("n", "gn", vim.diagnostic.goto_next)
vim.keymap.set("n", "gN", vim.diagnostic.goto_prev)
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
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
		-- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		-- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		-- vim.keymap.set("n", "<space>wl", function()
		--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		-- end, opts)
		vim.keymap.set("n", "<Leader>d", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<Leader>rd", vim.lsp.buf.rename, opts)
		-- vim.keymap.set({"n","v"}, "<Leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<Leader>f", function() vim.lsp.buf.format { async = true } end, opts)
	end,
})
