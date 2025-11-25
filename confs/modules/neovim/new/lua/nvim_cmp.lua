declare_file("nvim_cmp")

--
local lspicons =
{
	Text = "Tx",
	Keyword = "kw",
	Snippet = "/\\",
	Operator = "+-",
	
	TypeParameter = "ty",
	Value = "xy",
	Variable = "xy",
	
	Constant = "XY",
	
	Interface = "  ",
	Module = "  ",
	
	Struct = "*{",
	Class = "&{",
	
	Field = ".x",
	Property = ".x",
	
	Method = "()",
	Function = "()",
	Constructor = "()",
	
	Enum = "E.",
	EnumMember = ".x",
	Unit = "  ",
	
	Color = "  ",
	File = "  ",
	Reference = "  ",
	Folder = "  ",
	
	Event = "  ",
}

--

local cmp = require('cmp')
cmp.setup({
	snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end, },
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local source_name = ({
				vsnip ="[SNIP]",
				nvim_lsp = "[LSP]",

				buffer = "[BUFF]",
				path = "[PATH]",
			})[entry.source.name]

			vim_item.menu = string.format('%s %s', source_name, vim_item.kind)
			vim_item.kind = lspicons[vim_item.kind]
			return vim_item
		end
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		-- { name = 'vsnip' },
	}, {
		{ name = 'buffer' },
		{ name = 'path' },
	}),
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.recently_used,
			require("clangd_extensions.cmp_scores"),
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})
