local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)

  use { "wbthomason/packer.nvim" } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim" } -- Useful lua functions used by lots of plugins
  use { "windwp/nvim-autopairs" } -- Autopairs, integrates with both cmp and treesitter
  use { "christoomey/vim-tmux-navigator", lazy = false }
  -- use { "JoosepAlviste/nvim-ts-context-commentstring" }
  use { "kyazdani42/nvim-web-devicons" }
  use {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
  }
  
  use { "akinsho/bufferline.nvim" }
  use { "nvim-lualine/lualine.nvim" }
  use { "akinsho/toggleterm.nvim" }
  use { "roobert/search-replace.nvim" }
  -- use { "lewis6991/impatient.nvim" }
  use { "lukas-reineke/indent-blankline.nvim" }
  -- use { "goolord/alpha-nvim" }
	use {"folke/which-key.nvim"}
  use {
    'echasnovski/mini.nvim',
    branch = 'stable'
  }

  use {
    'ruifm/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
  }

  use({
      "lmburns/lf.nvim",
      requires = {"plenary.nvim", "toggleterm.nvim"}
  })

  use {
    "chrisgrieser/nvim-recorder",
    config = function() require("recorder").setup() end,
  }
  use { "gennaro-tedesco/nvim-peekup" }
  
	-- Colorschemes
  use { "sainnhe/everforest" }
  use { "rmehri01/onenord.nvim" }

	-- Cmp 
 --  use { "hrsh7th/nvim-cmp" } -- The completion plugin
 --  use { "hrsh7th/cmp-buffer" } -- buffer completions
 --  use { "hrsh7th/cmp-path" } -- path completions
	-- use { "saadparwaiz1/cmp_luasnip" } -- snippet completions
	-- use { "hrsh7th/cmp-nvim-lsp" }
	-- use { "hrsh7th/cmp-nvim-lua" }
	--
	-- -- Snippets
 --  use { "L3MON4D3/LuaSnip" } --snippet engine
 --  use { "rafamadriz/friendly-snippets" } -- a bunch of snippets to use
	--
	-- LSP
	-- use { "neovim/nvim-lspconfig" } -- enable LSP
  -- use { "williamboman/mason.nvim" } -- simple to use language server installer
  -- use { "williamboman/mason-lspconfig.nvim" }
	-- use { "jose-elias-alvarez/null-ls.nvim" } -- for formatters and linters
  -- use { "RRethy/vim-illuminate" }

	-- Telescope
  use { "nvim-telescope/telescope-live-grep-args.nvim" }
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = 'make'
  }
	use {
	  "nvim-telescope/telescope.nvim",
	  requires = {
	    "nvim-lua/plenary.nvim",
	    "nvim-telescope/telescope-live-grep-args.nvim" ,
      "nvim-lua/popup.nvim",
	  }
	}
  -- use { "nvim-telescope/telescope-project.nvim", requires = { "nvim-telescope/telescope.nvim" } }
	use { "stefandtw/quickfix-reflector.vim" }
	use { "milkypostman/vim-togglelist" }
  use {
    "AckslD/nvim-neoclip.lua",
    requires = {
      'nvim-telescope/telescope.nvim'
    }
  }
  use { "ahmedkhalf/project.nvim" }
	use { "rcarriga/nvim-notify" }
	use { "tpope/vim-repeat" }
	use { "ThePrimeagen/harpoon" }

	use {"folke/noice.nvim",
	   requires = {
	     "MunifTanjim/nui.nvim",
	     "rcarriga/nvim-notify"

	   },
	   config = function()
	       require("noice").setup({
	         lsp = {
	           -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
	           override = {
	             ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
	             ["vim.lsp.util.stylize_markdown"] = true,
	             ["cmp.entry.get_documentation"] = true,
	           },
	         },
	         -- you can enable a preset for easier configuration
	         presets = {
	           bottom_search = true, -- use a classic bottom cmdline for search
	           command_palette = true, -- position the cmdline and popupmenu together
	           long_message_to_split = true, -- long messages will be sent to a split
	           inc_rename = false, -- enables an input dialog for inc-rename.nvim
	           lsp_doc_border = false, -- add a border to hover docs and signature help
	         },
	       })
	   end
	 }

	-- YAML
  --
  use({"ggandor/lightspeed.nvim"})
  use {
    "cuducos/yaml.nvim",
    requires = {
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  }
  -- Git
	-- Treesitter
	use {"nvim-treesitter/nvim-treesitter"}
	use {"nvim-treesitter/nvim-treesitter-context",
    config = function() require('treesitter-context').setup() end
  }

  -- Git
	use { "lewis6991/gitsigns.nvim" }

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
