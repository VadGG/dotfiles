local overrides = require "custom.configs.overrides"
local is_lsp_enabled = false

-- TODO: multi clone and rename to LF
-- TODO: vimdiff windo diffthis, diffoff with colors
-- TODO: open recent files
-- TODO: search from the open directory like default
-- TODO: simple vim config with easy save-quit
-- TODO: change bracket plugin
-- TODO: lf filter
--

---@type NvPluginSpec[]
local plugins = {

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
    enabled = is_lsp_enabled,
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
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  ----------------------------------------------------------- FILE BROWSER
  {
    "lmburns/lf.nvim",
    lazy = false,
    cmd = "Lf",
    dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
    opts = {
      winblend = 0,
      highlights = { NormalFloat = { guibg = "NONE" } },
      border = "single", -- border kind: single double shadow curved
      escape_quit = false,

      mappings = true,

      layout_mapping = "<A-u>", -- resize window with this key

      views = { -- window dimensions to rotate through
        { width = 0.950, height = 0.950 },
        { width = 0.800, height = 0.850 },
      }
    },

    keys = {
      { "<leader>d", "<cmd>Lf<cr>", desc = "File Explorer" },
    },
  },
  ------------------------------------------------------------ NAVIGATION
  {
    "ggandor/lightspeed.nvim",
    lazy = false,
    opts = {
      ignore_case = false,
      exit_after_idle_msecs = { unlabeled = nil, labeled = nil },
      --- s/x ---
      jump_to_unique_chars = false,
      match_only_the_start_of_same_char_seqs = true,
      force_beacons_into_match_width = false,
      -- Display characters in a custom way in the highlighted matches.
      substitute_chars = { ["\r"] = "¬" },
      -- Leaving the appropriate list empty effectively disables "smart" mode,
      -- and forces auto-jump to be on or off.
      -- safe_labels = { . . . },
      -- labels = { . . . },
      -- These keys are captured directly by the plugin at runtime.
      special_keys = {
        next_match_group = "<space>",
        prev_match_group = "<tab>",
      },
      --- f/t ---
      limit_ft_matches = 5,
      repeat_ft_with_target_char = true,
    },
    config = function(_, opts)
      vim.api.nvim_exec(
        [[
              highlight LightspeedCursor guibg=#ffffff guifg=#000000
              highlight LightspeedOneCharMatch guibg=#fb4934 guifg=#fbf1c7

          ]],
        false
      )
    end,
  },
  ------------------------------------------------------- UTILS
  {
    "tpope/vim-repeat",
    lazy = false,
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
    opts = {
      n_lines = 500,
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    }, 

  },

  {
    "chrisgrieser/nvim-recorder",
    opts = {},
    lazy = false,
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
    init = function()
      vim.cmd [[
            hi BqfPreviewBorder guifg=#3e8e2d ctermfg=71
            hi BqfPreviewTitle guifg=#3e8e2d ctermfg=71
            hi BqfPreviewThumb guibg=#3e8e2d ctermbg=71
            hi link BqfPreviewRange Search
        ]]
      local fn = vim.fn

      function _G.qftf(info)
        local items
        local ret = {}
        -- The name of item in list is based on the directory of quickfix window.
        -- Change the directory for quickfix window make the name of item shorter.
        -- It's a good opportunity to change current directory in quickfixtextfunc :)
        --
        -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
        -- local root = getRootByAlterBufnr(alterBufnr)
        -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
        --
        if info.quickfix == 1 then
          items = fn.getqflist({ id = info.id, items = 0 }).items
        else
          items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
        end
        local limit = 31
        local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
        local validFmt = "%s │%5d:%-3d│%s %s"
        for i = info.start_idx, info.end_idx do
          local e = items[i]
          local fname = ""
          local str
          if e.valid == 1 then
            if e.bufnr > 0 then
              fname = fn.bufname(e.bufnr)
              if fname == "" then
                fname = "[No Name]"
              else
                fname = fname:gsub("^" .. vim.env.HOME, "~")
              end
              -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
              if #fname <= limit then
                fname = fnameFmt1:format(fname)
              else
                fname = fnameFmt2:format(fname:sub(1 - limit))
              end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
            str = validFmt:format(fname, lnum, col, qtype, e.text)
          else
            str = e.text
          end
          table.insert(ret, str)
        end
        return ret
      end

      vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
    end,
    opts = {},
  },
  ---------------------------------------- SEARCH AND REPLACE
  {
    "roobert/search-replace.nvim",
    config = function()
      require("search-replace").setup {
        -- optionally override defaults
        default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      }
    end,
    opts = {
      defaults = {
        mappings = {
          v = {
            ["<C-r>"] = "<CMD>SearchReplaceSingleBufferVisualSelection<CR>",
            ["<C-s>"] = "<CMD>SearchReplaceWithinVisualSelection<CR>",
            ["<C-b>"] = "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>",
          },
        },
      },
    },

    keys = {
      {
        "<leader>rs",
        "<CMD>SearchReplaceSingleBufferSelections<CR>",
        desc = "[s]elction list",
      },
      { "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", desc = "[o]pen" },
      { "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", desc = "[w]ord" },
      { "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", desc = "[W]ord" },
      { "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", desc = "[e]xpr" },
      { "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", desc = "[f]ile" },

      {
        "<leader>rbs",
        "<CMD>SearchReplaceMultiBufferSelections<CR>",
        desc = "[s]elction list",
      },
      { "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", desc = "[o]pen" },
      { "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", desc = "[w]ord" },
      { "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", desc = "[W]ord" },
      { "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", desc = "[e]xpr" },
      { "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", desc = "[f]ile" },
    },
  },
  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>rr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- TODO: move to proper place
  {
    "folke/which-key.nvim",
    optional = true,
    lazy=false,
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
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
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
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    lazy = false,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>tx", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>tX", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>ts", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>tS", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  ---------------------------------------------------------------- TELESCOPE
  {
    "AckslD/nvim-neoclip.lua",
    opts = {},
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function(_, opts)
      require("neoclip").setup(opts)
      local telescope = require "telescope"
      telescope.load_extension "neoclip"
    end,
    keys = {
      { "<leader>fp", "<cmd>Telescope neoclip theme=dropdown<cr>", desc = "Clipboard" },
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
    --         prompt_prefix = "﬘ ",
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
