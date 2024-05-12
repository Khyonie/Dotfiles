local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#14121f',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
  white = '#f3f3f3',
  light_green = '#83a598',
  orange = '#fe8019',
  green = '#8ec07c',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.black, bg = colors.black },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = '#A0A0A0', bg = colors.black },
    b = { fg = '#A0A0A0', bg = colors.black },
    c = { fg = '#A0A0A0', bg = colors.black },
  },
}

local theme = {
  normal = {
    a = { fg = colors.white, bg = colors.blue },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.black, bg = '#808080' },
    z = { fg = colors.white, bg = colors.black },
  },
  insert = { a = { fg = colors.black, bg = colors.violet } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },
}

local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
  self.status = ''
  self.applied_separator = ''
  self:apply_highlights(default_highlight)
  self:apply_section_separators()
  return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
  for name, section in pairs(sections) do
    local left = name:sub(9, 10) < 'x'
    for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
      table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
    end
    for id, comp in ipairs(section) do
      if type(comp) ~= 'table' then
        comp = { comp }
        section[id] = comp
      end
      comp.separator = left and { right = '' } or { left = '' }
    end
  end
  return sections
end

local function search_result()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local last_search = vim.fn.getreg('/')
  if not last_search or last_search == '' then
    return ''
  end
  local searchcount = vim.fn.searchcount { maxcount = 9999 }
  return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

local function modified()
  if vim.bo.modified then
    return '+'
  elseif vim.bo.modifiable == false or vim.bo.readonly == true then
    return '-'
  end
  return ''
end

require('lualine').setup {
	options = {
    	theme = theme,
    	component_separators = '|',
		section_separators = { left = '', right = '' },
    	-- section_separators = { left = '', right = '' },
  	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'filename', 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'fileformat', 'lsp_progress' },
		lualine_x = {},
		lualine_y = { 'filetype', 'progress' },
		lualine_z = { 'location' },
	},
	inactive_sections = {
		lualine_a = { },
		lualine_b = { 'filename' },
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { 'location' },
	},
	tabline = {},
	extensions = {},
}
