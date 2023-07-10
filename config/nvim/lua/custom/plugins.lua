local overrides = require "custom.configs.overrides"
local is_lsp_enabled = true

-- TODO: open recent files
-- TODO: search from the open directory like default
-- TODO: simple vim config with easy save-quit
-- TODO: change bracket plugin
-- TODO: lf filter
-- TODO: don't auto-show autocomplete menu
--
--

---@type NvPluginSpec[]
local plugins = {

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    enabled = is_lsp_enabled,
    opts = overrides.mason.opts,
  },

  { "neovim/nvim-lspconfig", enabled = is_lsp_enabled },
  { "hrsh7th/nvim-cmp", enabled = is_lsp_enabled },
  { "L3MON4D3/LuaSnip", enabled = is_lsp_enabled },
  { "saadparwaiz1/cmp_luasnip", enabled = is_lsp_enabled },
  { "hrsh7th/cmp-nvim-lua", enabled = is_lsp_enabled },
  { "hrsh7th/cmp-nvim-lsp", enabled = is_lsp_enabled },
  { "hrsh7th/cmp-buffer", enabled = is_lsp_enabled },
  { "hrsh7th/cmp-path", enabled = is_lsp_enabled },
  -- Override plugin definition options

  {
    "NvChad/nvterm",
    enabled = false,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = overrides.lspconfig.config,
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter.opts,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree.opts,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = overrides.betterescape.config,
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "folke/noice.nvim",
    event = "UIEnter",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = overrides.noice.config,
  },

  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    config = function()
      require("diffview").setup {
        enhanced_diff_hl = true,
        view = {
          merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = true,
          },
        },
      }
    end,
  },

  ----------------------------------------------------------- FILE BROWSER
  {
    "lmburns/lf.nvim",
    lazy = false,
    cmd = "Lf",
    dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
    opts = overrides.lfnvim.opts,
  },
  ------------------------------------------------------------ NAVIGATION
  {
    "ggandor/lightspeed.nvim",
    lazy = false,
    opts = overrides.lightspeed.opts,
    config = overrides.lightspeed.config,
  },

  ------------------------------------------------------- UTILS
  {
    "tpope/vim-repeat",
    lazy = false,
    config = function() end,
  },

  -- auto pairs
  {
    "echasnovski/mini.pairs",
    lazy = false,
    opts = {},
  },

  {
    "echasnovski/mini.move",
    lazy = false,
    opts = {},
  },

  -- surround
  {
    "echasnovski/mini.surround",
    lazy = false,
    opts = overrides.minisurround.opts,
  },

  {
    "chrisgrieser/nvim-recorder",
    lazy = false,
    opts = {},
  },

  ----------------------------------------------------------- QUICK-FIX
  {
    "milkypostman/vim-togglelist",
    lazy = false,
    config = function() end,
  },

  {
    "kevinhwang91/nvim-bqf",
    lazy = false,
    init = overrides.bqf.init,
    opts = {},
  },
  ---------------------------------------- SEARCH AND REPLACE
  {
    "roobert/search-replace.nvim",
    lazy = false,
    opts = overrides.searchreplace.opts,
    config = overrides.searchreplace.config,
  },

  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = overrides.spectre.opts,
    -- stylua: ignore
  },

  -- TODO: move to proper place
  {
    "folke/which-key.nvim",
    optional = true,
    lazy = false,
    opts = {
      defaults = {
        ["<leader>rb"] = { name = "+Replace Multi-buffer" },
      },
    },
  },
  -------------------------------------------------------------------------------- INDENTSCOPE
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = overrides.indentscope.opts,
    init = overrides.indentscope.init,
  },

  {
    "ruifm/gitlinker.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      require("gitlinker").setup(opts)
    end,
  },
  ---------------------------------------------------------------- TODO
  {
    "folke/todo-comments.nvim",
    lazy = false,
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    config = function()
      require "custom.configs.todo"
    end,
    -- stylua: ignore
  },
  ---------------------------------------------------------------- TELESCOPE
  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      {
        "AckslD/nvim-neoclip.lua",
        config = overrides.neoclip.config,
      },

      {
        "ahmedkhalf/project.nvim",
        lazy = false,
        opts = overrides.project.opts,
        config = function(_, opts)
          require("project_nvim").setup(opts)
        end,
      },
      {
        "ThePrimeagen/harpoon",
        cmd = "Harpoon",
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "kkharji/sqlite.lua" },
      },
    },
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
