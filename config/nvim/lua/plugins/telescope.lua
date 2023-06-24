return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-live-grep-args.nvim",
    "ThePrimeagen/harpoon",
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    {
      "ahmedkhalf/project.nvim",
      opts = {},
      event = "VeryLazy",
      config = function(_, opts)
        require("project_nvim").setup(opts)
        require("telescope").load_extension("projects")
      end,
      keys = {
        { "<leader>fo", "<Cmd>Telescope projects<CR>", desc = "Projects" },
      },
    },

    {
      "AckslD/nvim-neoclip.lua",
      opts = {},
      event = "VeryLazy",
      config = function()
        require("neoclip").setup()
        local telescope = require("telescope")
        telescope.load_extension("neoclip")
      end,
      keys = {
        { "<leader>fp", "<cmd>Telescope neoclip theme=dropdown<cr>", desc = "Clipboard" },
      },
    },
  },
  cmd = "Telescope",
  version = false, -- telescope did only one release, so use HEAD for now
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")
    -- telescope.load_extension("notify")
    telescope.load_extension("harpoon")
  end,
  keys = {
    {
      "<leader><space>",
      "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({previewer = false}))<cr>",
      desc = "Find Files (no preview)",
    },
    { "<leader>fg", "<cmd>lua require'telescope'.extensions.live_grep_args.live_grep_args()<CR>", desc = "Grep" },
    {
      "<leader>fG",
      "<cmd>lua  require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<CR>",
      desc = "Grep Word under cursor",
    },
    {
      "<leader>fb",
      "<cmd>lua require'telescope.builtin'.buffers({ ignore_current_buffer = true, sort_mru = true})<cr>",
      desc = "Buffers",
    },
    { "<leader>/", "<cmd>lua require'telescope'.extensions.live_grep_args.live_grep_args()<CR>", desc = "Grep" },
  },
  opts = function()
    local actions = require("telescope.actions")
    return {

      defaults = {

        prompt_prefix = "  ",
        selection_caret = "  ",
        path_display = { "absolute" },
        initial_mode = "insert",
        layout_config = {
          vertical = {
            prompt_position = "top",
            mirror = "true",
            layout_config = { height = 0.95 },
          },
        },
      },
      pickers = {
        find_files = {
          prompt_prefix = " ",
          find_command = { "rg", "--files", "--hidden" },
        },
        live_grep = {
          layout_strategy = "vertical",
          sorting_strategy = "ascending",
        },
        commands = {
          prompt_prefix = " ",
          initial_mode = "insert",
        },
        git_files = {
          prompt_prefix = " ",
          show_untracked = true,
        },
        buffers = {
          initial_mode = "normal",
          prompt_prefix = "﬘ ",
          mappings = {
            i = {
              ["<C-d>"] = require("telescope.actions").delete_buffer,
            },
            n = {
              ["d"] = require("telescope.actions").delete_buffer,
              ["q"] = function(...)
                return require("telescope.actions").close(...)
              end,
            },
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
        neoclip = {
          initial_mode = "normal",
          layout_strategy = "vertical",
        },
        projects = {
          initial_mode = "normal",
          layout_strategy = "vertical",
          previewer = false,
        },
        live_grep_args = {
          initial_mode = "insert",
          layout_strategy = "vertical",
          sorting_strategy = "ascending",
        },
      },
    }
  end,
}
