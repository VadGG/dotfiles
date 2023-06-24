local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

telescope.setup {
  defaults = {

    prompt_prefix = "  ",
    selection_caret = "  ",
    path_display = { "absolute" },
    initial_mode = "normal",
   
    layout_config = {
      vertical = {
        prompt_position = "top",
        mirror = "true",
        layout_config = { height = 0.95 }
      }
    },
    
    

  },
  pickers = {
    find_files = {
        initial_mode = "insert"
    },
    live_grep = {
        initial_mode = "insert",
        layout_strategy = 'vertical',
        sorting_strategy = 'ascending'
    },
    commands = {
        initial_mode = "insert"
    },
    buffers = {
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["d"] = actions.delete_buffer,
          }
        }
    }

    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    },
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
    },
    live_grep_args = {
      initial_mode = "insert"
    },
    live_grep_args = {
        initial_mode = "insert",
        layout_strategy = 'vertical',
        sorting_strategy = 'ascending'
    },
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  },
}

telescope.load_extension('fzf')
telescope.load_extension("live_grep_args")
