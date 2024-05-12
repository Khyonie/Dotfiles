-- Vim preferences
-- vim.g.mapleader = ' '
-- vim.g.maplocalheader = ' '

-- vim.opt.backspace = '2'
-- vim.opt.showcmd = true
-- vim.opt.laststatus = 2
-- vim.opt.autowrite = true
-- vim.opt.cursorline = false
-- vim.opt.autoread = true

vim.o.tabstop = 4
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 4
vim.o.cursorline = true

vim.wo.wrap = false

--vim.cmd(':colorscheme rose-pine')
vim.cmd(':hi IndentBlanklineChar guifg=#21202e')
vim.cmd(':hi IndentBlanklineContextChar guifg=#403d52')

-- Border settings

local border = {
      {"╭", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╮", "FloatBorder"},
      {"│", "FloatBorder"},
      {"╯", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╰", "FloatBorder"},
      {"│", "FloatBorder"},
}

vim.lsp.handlers["textDocument/hover"] = 
	vim.lsp.with(
		vim.lsp.handlers.hover,
		{
			border = border
		}
	)

vim.lsp.handlers["textDocument.signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{
			border = border
		}
	)

vim.lsp.handlers["textDocument/publishDiagnostics"] = 
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		underline = true,
		signs = true
	}

vim.diagnostic.config({
	virtual_text = true,
	float = {
		border = border
	}
})

-- Keymaps
vim.keymap.set('n', '<C-s>', ':w<CR>')
vim.keymap.set('i', '<C-s>', '<ESC>:w<CR>')
vim.keymap.set('n', '<C-.>', require('actions-preview').code_actions )
vim.keymap.set('n', '<C-\'>', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<C-f>', ':Telescope<CR>')
vim.keymap.set('n', '<C-`>', ':! ')
vim.keymap.set('i', '<C-`>', '<ESC>:! ')
vim.keymap.set('n', '<C-,>', function() return vim.lsp.buf.hover() end)
vim.keymap.set({'i', 'n'}, '<C-h>', '<ESC>:BufferPrevious<CR>')
vim.keymap.set({'i', 'n'}, '<C-l>', '<ESC>:BufferNext<CR>')
vim.keymap.set('n', '<C-n>', function() return vim.diagnostic.goto_next() end)
vim.keymap.set('n', '<C-S-n>', function()  vim.diagnostic.goto_prev() end)
