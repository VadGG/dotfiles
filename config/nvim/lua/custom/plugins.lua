local overrides = require "custom.configs.overrides"
local is_lsp_enabled = true

-- TODO: multi clone and rename to LF
-- TODO: vimdiff windo diffthis, diffoff with colors
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

  ----------------------------------------------------------- FILE BROWSER
  {
    "lmburns/lf.nvim",
    lazy = false,
    cmd = "Lf",
    dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
    opts = overrides.lfnvim.opts,
    keys = {
      { "<leader>d", "<cmd>Lf<cr>", desc = "File Explorer" },
    },
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
    keys = {
      { "<leader>rr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
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
        require("core.utils").load_mappings "gitlinker"
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
      "AckslD/nvim-neoclip.lua",
      opts = {},
      event = "VeryLazy",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = overrides.neoclip.config,
      keys = {
        { "<leader>fp", "<cmd>Telescope neoclip theme=dropdown<cr>", desc = "Clipboard" },
      },
    },

    {
      "ahmedkhalf/project.nvim",
      opts = overrides.project.opts,
      event = "VeryLazy",
      config = function(_, opts)
        require("project_nvim").setup(opts)
        require("telescope").load_extension "projects"
      end,
      keys = {
        { "<leader>oo", "<Cmd>Telescope projects<CR>", desc = "Projects" },
        { "<leader>oa", "<Cmd>AddProject<CR>", desc = "Add Project" },
        { "<leader>or", "<Cmd>ProjectRoot<CR>", desc = "Root Project" },
      },
    },

    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function(_, opts)
        local telescope = require "telescope"
        telescope.setup(opts)
        require("telescope").load_extension "fzf"
      end,
    },

    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function(_, opts)
        local telescope = require "telescope"
        telescope.setup(opts)
        require("telescope").load_extension "live_grep_args"
      end,
      keys = {
        {
          "<leader>fg",
          "<Cmd>lua require'telescope'.extensions.live_grep_args.live_grep_args()<CR>",
          desc = "Live Grep Args",
        },
        {
          "<leader>fw",
          "<cmd>lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<CR>",
          desc = "Live Grep Under Cursor",
        },
      },
    },

    {
      "nvim-telescope/telescope.nvim",
      -- extensions_list = { "themes", "terms", "fzf", "live_grep_args", "projects", "neoclip"},
      -- dependencies = { "nvim-telescope/telescope-live-grep-args.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
      keys = {
        {
          "<leader>fF",
          "<cmd>lua require'telescope.builtin'.find_files({ cwd = vim.fn.expand('%:p:h') })<cr>",
          desc = "Find directory",
        },
      },
    },

    -- opts = function()
    --   return {
    --     pickers = {
    --       find_files = {
    --         prompt_prefix = " ",
    --         -- find_command = { "rg", "--files", "--hidden" },
    --       },
    --       live_grep = {
    --         -- layout_strategy = "vertical",
    --         sorting_strategy = "ascending",
    --       },
    --       commands = {
    --         prompt_prefix = " ",
    --         initial_mode = "insert",
    --       },
    --       git_files = {
    --         prompt_prefix = " ",
    --         show_untracked = true,
    --       },
    --       buffers = {
    --         initial_mode = "normal",
    --         prompt_prefix
    --         mappings = {
    --           i = {
    --             ["<C-d>"] = require("telescope.actions").delete_buffer,
    --           },
    --           n = {
    --             ["d"] = require("telescope.actions").delete_buffer,
    --             ["q"] = function(...)
    --               return require("telescope.actions").close(...)
    --             end,
    --           },
    --         },
    --       },
    --     },
    --     extensions = {
    --       fzf = {
    --         fuzzy = true, -- false will only do exact matching
    --         override_generic_sorter = true, -- override the generic sorter
    --         override_file_sorter = true, -- override the file sorter
    --         case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    --       },
    --       neoclip = {
    --         initial_mode = "normal",
    --         -- layout_strategy = "vertical",
    --       },
    --       projects = {
    --         initial_mode = "normal",
    --         -- layout_strategy = "vertical",
    --         previewer = false,
    --       },
    --       live_grep_args = {
    --         initial_mode = "insert",
    --         -- layout_strategy = "vertical",
    --         sorting_strategy = "ascending",
    --       },
    --     },
    --   }
    -- end,
  },

  -- {
  --   "nvim-telescope/telescope.nvim",
  --   opts = {
  --     defaults = {
  --       layout_strategy = "vertical",
  --       layout_config = {
  --         height = 0.95,
  --         prompt_position = "top",
  --         vertical = {
  --           mirror = true,
  --           preview_cutoff = 0,
  --         },
  --       },
  --     },
  --   },
  -- },

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
