declare_plugin_config("nvim_cmp")

local cmp = require_plugin("cmp")

--
local lspicons = {
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

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) 		-- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) 	-- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) 		-- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-k>'] = cmp.mapping.scroll_docs(-4),
		['<C-j>'] = cmp.mapping.scroll_docs(4),
		-- ['<C-Space>'] = cmp.mapping.complete(),
		-- ['<ESC>'] = cmp.mapping.abort(),
		['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
		{ name = 'vsnip' },
		{ name = 'nvim_lsp' },

		-- { name = 'luasnip' },
		-- { name = 'ultisnips' },
		-- { name = 'snippy' },
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

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
