vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require('nvim-tree').setup({
	view = {
		adaptive_size = true,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
        	hint = "",
        	info = "",
        	warning = "",
			error = "",
    	},
	},
})

local api = require('nvim-tree.api')
local Event = api.events.Event

api.events.subscribe(Event.FileCreated, function(data)
	vim.cmd(':e '.. data.fname)
end)
