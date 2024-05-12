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

local outline = require("outline")
local config = {
	outline_window = {
		width = 15,
		show_numbers = true,
	},
	preview_window = {
		auto_preview = true,
		open_hover_on_preview = true,
		border = border,
	}
}

local trouble = require("trouble")

outline.setup(config)
local providers = require("outline.providers")

local function open_outline(open_trouble)
	if not providers.has_provider() then
		print("No provider available")
		return
	end

	if not outline.is_open() then
		outline.open(config)
		if open_trouble then
			trouble.open()
		end

		return 
	end

	if not outline.has_focus() then
		return outline.focus_outline()
	end

	outline.focus_code()
end

vim.keymap.set({'i', 'n'}, '<C-j>', function() return open_outline(false) end)
vim.keymap.set({'i', 'n'}, '<C-S-j>', function() return open_outline(true) end)
