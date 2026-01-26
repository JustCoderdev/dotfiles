declare_file("plugin:lsp")


local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('nixd', { capabilities = capabilities })
vim.lsp.config('clangd', { capabilities = capabilities })
vim.lsp.config('rust_analyzer', { capabilities = capabilities })


vim.lsp.enable('nixd')
vim.lsp.enable('clangd')
vim.lsp.enable('rust_analyzer')


-- File type fixes
-- #----------------------------------------------------------# --

-- Thanks yochem for this function, you are the best <3
-- <https://github.com/neovim/neovim/issues/22768#issuecomment-1482750463>

local function set_filetype_option(ft, option, value)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = ft,
		group = vim.api.nvim_create_augroup('FtOptions', {}),
		desc = ('set option "%s" to "%s" for this filetype'):format(option, value),
		callback = function()
			vim.opt_local[option] = value
		end
	})
end

-- #------------------# --

set_filetype_option({'c', 'c++'}, 'commentstring', '/* %s */')
