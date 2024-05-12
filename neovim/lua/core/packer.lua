local ensure_packer = function()
	local fn = vim.fn
  	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  	if fn.empty(fn.glob(install_path)) > 0 then
    	fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    	vim.cmd [[packadd packer.nvim]]
    	return true
  	end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	-- Core functionality
	use 'nvim-tree/nvim-tree.lua'
	use 'nvim-treesitter/nvim-treesitter'
	use 'nvim-tree/nvim-web-devicons'
  	use 'nvim-lualine/lualine.nvim'
	use {
		'lukas-reineke/indent-blankline.nvim',
		commit = '9637670'
	}
	use 'norcalli/nvim-colorizer.lua'
	--use 'wfxr/minimap.vim'
	use 'romgrk/barbar.nvim'
	use "windwp/nvim-autopairs"
	use 'andweeb/presence.nvim'
	use 'arkav/lualine-lsp-progress'
	use 'hedyhli/outline.nvim'

	-- LSPs
	use 'neovim/nvim-lspconfig'
	use 'mfussenegger/nvim-jdtls'
	use 'simrat39/rust-tools.nvim'

	-- Telescope
	use "nvim-lua/plenary.nvim"
	use {
		'nvim-telescope/telescope.nvim', 
		tag = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use 'MunifTanjim/nui.nvim'

	-- Completion
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'

	use ({
		'weilbith/nvim-code-action-menu',
  		cmd = 'CodeActionMenu',
	})

	use "aznhe21/actions-preview.nvim"

	use 'folke/trouble.nvim'
	use 'm-demare/hlargs.nvim'
	use 'shaunsingh/moonlight.nvim'
	
	-- Themes
	use ({
		'rose-pine/neovim',
    	as = 'rose-pine',
	})

	-- Automatically set up your configuration after cloning packer.nvim
  	-- Put this at the end after all plugins
	if packer_bootstrap then
    	require('packer').sync()
  	end
end)
