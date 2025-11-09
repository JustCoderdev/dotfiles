declare_plugin_config("nvim_lspconfig")

-- Open logs:
-- :lua vim.cmd('e'..vim.lsp.get_log_path())

-- Need to be called after plugins:
-- 	  - language extensions
-- 	  - nvim_cmp
-- 	  - lsp_signature

-- Migration guide:
-- <https://xnacly.me/posts/2025/neovim-lsp-changes/#previous-configuration-via-lsp-config>

local snip_cap = require('cmp_nvim_lsp').default_capabilities()
snip_cap.textDocument.completion.completionItem.snippetSupport = true

local c_cap = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
c_cap.textDocument.completion.completionItem.snippetSupport = true
c_cap.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

local lsps =
{

-- Web
	-- npm i -g vscode-langservers-extracted
	-- { "html",   { capabilities = snip_cap } },
	-- { "cssls",  { capabilities = snip_cap } },
	-- { "jsonls", { capabilities = snip_cap } },
	-- { "eslint", { capabilities = snip_cap } },

	-- npm i -g css-variables-language-server
	-- { "css_variables", { capabilities = snip_cap } },

-- Tools
	{ "nixd",     { cmd = { "/usr/bin/env" "nixd" }, capabilities = snip_cap } },
	-- { "marksman", { capabilities = snip_cap } },
	-- { "dockerls", { capabilities = snip_cap } },
	-- { "bashls", { capabilities = snip_cap } },
	-- {
	-- 	"lua_ls",
	-- 	{
	-- 		on_init = function(client)
	-- 			local path = client.workspace_folders[1].name
	-- 			if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
	-- 				client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
	-- 					Lua = {
	-- 						diagnostics = { globals = { 'vim' } },
	-- 						runtime = { version = 'LuaJIT' },
	-- 						workspace = { library = {
	-- 							[vim.fn.expand('$VIMRUNTIME/lua')] = true,
	-- 							[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
	-- 						} },
	-- 					}
	-- 				})
	-- 				client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
	-- 			end
	-- 			return true
	-- 		end,
	-- 		settings = { Lua = { completion = { callSnippet = "Replace" } } }
	-- 	}
	-- }

-- C
	{
		"clangd",
		{
			cmd = { "/usr/bin/env" "clangd" },

			on_attach = function(client, bufnr)
				require("clangd_extensions.inlay_hints").setup_autocmd()
				require("clangd_extensions.inlay_hints").set_inlay_hints()
			end,

			init_options = {
				capabilities = c_cap,
				fallbackFlags = {
					"-std=c89", "-ansi", "-pedantic-errors", "-pedantic",
					"-Wall", "-Wextra", "-Werror", "-Wshadow", "-Wpointer-arith",
					"-Wcast-qual", "-Wcast-align", "-Wstrict-prototypes",
					"-Wmissing-prototypes", "-Wconversion", "-g",
					"-Wno-unused-variable", "-Wfatal-errors",
				}
			},
		}
	},
}


for _, lsp in pairs(lsps)
do
	local name, config = lsp[1], lsp[2]
	vim.lsp.enable(name)
	if config then vim.lsp.config(name, config) end
end


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
		-- vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
		vim.keymap.set("n", "<Alt>n", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<Alt>p", vim.diagnostic.goto_prev, opts)
		--AAA
		vim.keymap.set("n", "<Leader>d", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<Leader>rd", vim.lsp.buf.rename, opts)
		-- vim.keymap.set({"n","v"}, "<Leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<Leader>f", function() vim.lsp.buf.format { async = true } end, opts)
	end,
})
