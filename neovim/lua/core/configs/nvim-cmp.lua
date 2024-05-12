local nvim_cmp = require('cmp')
nvim_cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {
		completion = nvim_cmp.config.window.bordered(),
		documentation = nvim_cmp.config.window.bordered(),
	},
	mapping = nvim_cmp.mapping.preset.insert({
      	['<C-b>'] = nvim_cmp.mapping.scroll_docs(-4),
    	['<C-f>'] = nvim_cmp.mapping.scroll_docs(4),
		['<C-Space>'] = nvim_cmp.mapping.complete(),
		['<C-e>'] = nvim_cmp.mapping.abort(),
		['<CR>'] = nvim_cmp.mapping.confirm({ select = true }), 
    }),
	sources = nvim_cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	})
})
