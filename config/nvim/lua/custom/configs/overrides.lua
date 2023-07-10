local M = {}

M.mason = {
  opts = {
    ensure_installed = {
      -- lua stuff
      -- "lua-language-server",
      -- "stylua",

      -- web dev stuff
      -- "css-lsp",
      -- "html-lsp",
      -- "typescript-language-server",
      -- "deno",
      -- "prettier",

      -- c/cpp stuff
      -- "clangd",
      -- "clang-format",
    },
  },
}

M.lspconfig = {
  config = function()
    require "plugins.configs.lspconfig"
    require "custom.configs.lspconfig"
  end, -- Override to setup mason-lspconfig
}

M.treesitter = {
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "json",
      "lua",
      "python",
      "yaml",
      "markdown_inline",
      "css",
      -- "vim",
      -- "html",
      -- "javascript",
      -- "typescript",
      -- "tsx",
      -- "markdown",
    },
    indent = {
      enable = true,
      -- disable = {
      --   "python"
      -- },
    },
  },
}

-- git support in nvimtree
M.nvimtree = {
  opts = {
    git = {
      enable = true,
    },

    renderer = {
      highlight_git = true,
      icons = {
        show = {
          git = true,
        },
      },
    },
  },
}

M.betterescape = {
  config = function()
    require("better_escape").setup()
  end,
}

M.noice = {
  config = function()
    local present, noice = pcall(require, "noice")

    if not present then
      return
    end

    noice.setup {
      cmdline = {
        format = {
          search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },

      notify = {
        enabled = true,
        view = "notify",
      },
    }
  end,
}

-- file browser lf
M.lfnvim = {
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
    },
  },
}

M.lightspeed = {
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
}

M.minisurround = {
  opts = {
    n_lines = 500,
    mappings = {
      add = "ys", -- Add surrounding in Normal and Visual modes
      delete = "ds", -- Delete surrounding
      find = "", -- Find surrounding (to the right)
      find_left = "", -- Find surrounding (to the left)
      highlight = "", -- Highlight surrounding
      replace = "cs", -- Replace surrounding
      update_n_lines = "", -- Update `n_lines`
    },
  },
}

M.bqf = {
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
}

M.searchreplace = {
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
  config = function()
    require("search-replace").setup {
      -- optionally override defaults
      default_replace_single_buffer_options = "gcI",
      default_replace_multi_buffer_options = "egcI",
    }
  end,
}

M.spectre = {
  opts = {
    open_cmd = "noswapfile vnew",
  },
}

M.indentscope = {
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
}

M.telescope = {
  extensions_list = { "themes", "terms", "fzf", "live_grep_args", "projects", "neoclip", "harpoon" },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden" },
    },
    buffers = {
      initial_mode = "normal",
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
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    frecency = {
      -- auto_validate = true,
    },
  },
}

M.neoclip = {
  opts = {
    history = 1000,
    enable_persistent_history = false,
    length_limit = 1048576,
    continuous_sync = false,
    preview = true,
    prompt = nil,
    default_register = '"',
    default_register_macros = "q",
    enable_macro_history = true,
    content_spec_column = false,
    disable_keycodes_parsing = false,
    on_select = {
      move_to_front = false,
      close_telescope = true,
    },
    on_paste = {
      set_reg = false,
      move_to_front = false,
      close_telescope = true,
    },
    on_replay = {
      set_reg = false,
      move_to_front = false,
      close_telescope = true,
    },
    on_custom_action = {
      close_telescope = true,
    },
  },
  config = function(_, opts)
    require("neoclip").setup(opts)
  end,
}

M.project = {
  opts = {
    manual_mode = true,
  },
}

return M
