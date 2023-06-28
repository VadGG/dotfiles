---@type MappingsTable
local M = {}

function _SET_CLIPBOARD(clip_value)
  local current_clip_value = vim.api.nvim_exec("set clipboard?", true)
  local current_value = string.match(current_clip_value, "=(.+)")
  if current_value == clip_value then
    clip_value = ""
  end
  vim.cmd("set clipboard=" .. clip_value)
  vim.cmd "set clipboard?"
end

local function newMapping(shortcut, desc)
  return { shortcut, desc, opts = { nowait = true } }
end

M.general = {
  n = {
    [";"] = newMapping(":", "enter command mode"),
    ["H"] = newMapping("^", "Begining of line"),
    ["L"] = newMapping("$", "End of line"),

    ["<leader>\\"] = newMapping( "<cmd>vs<CR>", "Vertical split" ),
    ["<leader>-"] = newMapping( "<cmd>sp<CR>", "Horizontal split" ),
    ["<leader>wq"] = newMapping( "<cmd>q<CR>", "Close Window" ),

    ["<C-Up>"] = newMapping( "<cmd>resize -10<cr>", "Resize Screen Up" ),
    ["<C-Down>"] = newMapping( "<cmd>resize +10<cr>", "Resize Screen Down" ),
    ["<C-Left>"] = newMapping( "<cmd>vertical resize -10<cr>", "Resize Screen Left" ),
    ["<C-Right>"] = newMapping( "<cmd>vertical resize +10<cr>", "Resize Screen Right" ),

    ["<C-h>"] = newMapping( "<cmd> TmuxNavigateLeft<cr>", "Move left" ),
    ["<C-l>"] = newMapping( "<cmd> TmuxNavigateRight<cr>", "Move right" ),
    ["<C-j>"] = newMapping( "<cmd> TmuxNavigateDown<cr>", "Move down" ),
    ["<C-k>"] = newMapping( "<cmd> TmuxNavigateUp<cr>", "Move up" ),

    ["`"] = {
      function()
        _SET_CLIPBOARD "unnamedplus"
      end,
      "Toggle clipboard",
    },
  },
  v = {
    ["H"] = newMapping("^", "Begining of line"),
    ["L"] = newMapping("$", "End of line"),

    ["<"] = newMapping( "<gv", "Indent left" ),
    [">"] = newMapping( ">gv", "Indent Right" ),

    ["<leader>\\"] = newMapping( "<cmd>vs<CR>", "Vertical split" ),
    ["<leader>-"] = newMapping( "<cmd>sp<CR>", "Horizontal split" ),
    ["<leader>wq"] = newMapping( "<cmd>q<CR>", "Close Window" ),

    ["<C-h>"] = newMapping( "<cmd> TmuxNavigateLeft<cr>", "Move left" ),
    ["<C-l>"] = newMapping( "<cmd> TmuxNavigateRight<cr>", "Move right" ),
    ["<C-j>"] = newMapping( "<cmd> TmuxNavigateDown<cr>", "Move down" ),
    ["<C-k>"] = newMapping( "<cmd> TmuxNavigateUp<cr>", "Move up" ),

    ["<C-Up>"] = newMapping( "<cmd>resize -10<cr>", "Resize Screen Up" ),
    ["<C-Down>"] = newMapping( "<cmd>resize +10<cr>", "Resize Screen Down" ),
    ["<C-Left>"] = newMapping( "<cmd>vertical resize -10<cr>", "Resize Screen Left" ),
    ["<C-Right>"] = newMapping( "<cmd>vertical resize +10<cr>", "Resize Screen Right" ),

    ["`"] = newMapping( function() _SET_CLIPBOARD "unnamedplus" end, "Toggle clipboard" ),
  },
}

M.searchreplace = {
  n = {
    ["<leader>rs"] = newMapping("<cmd>SearchReplaceSingleBufferSelections<cr>", "[s]election list"),
    ["<leader>ro"] = newMapping("<CMD>SearchReplaceSingleBufferOpen<CR>", "[o]pen"),
    ["<leader>rw"] = newMapping("<CMD>SearchReplaceSingleBufferCWord<CR>", "[w]ord"),
    ["<leader>rW"] = newMapping("<CMD>SearchReplaceSingleBufferCWORD<CR>", "[W]ord"),
    ["<leader>re"] = newMapping("<CMD>SearchReplaceSingleBufferCExpr<CR>", "[e]xpr"),
    ["<leader>rf"] = newMapping("<CMD>SearchReplaceSingleBufferCFile<CR>", "[f]ile"),
    ["<leader>rbs"] = newMapping("<CMD>SearchReplaceMultiBufferSelections<CR>", "[s]election list"),
    ["<leader>rbo"] = newMapping("<CMD>SearchReplaceMultiBufferOpen<CR>", "[o]pen"),
    ["<leader>rbw"] = newMapping("<CMD>SearchReplaceMultiBufferCWord<CR>", "[w]ord"),
    ["<leader>rbW"] = newMapping("<CMD>SearchReplaceMultiBufferCWORD<CR>", "[W]ord"),
    ["<leader>rbe"] = newMapping("<CMD>SearchReplaceMultiBufferCExpr<CR>", "[e]xpr"),
    ["<leader>rbf"] = newMapping("<CMD>SearchReplaceMultiBufferCFile<CR>", "[f]ile"),
  },
  v = {
    ["<C-r>"] = newMapping("<cmd>SearchReplaceSingleBufferVisualSelection<cr>", "Replace selected"),
    ["<C-s>"] = newMapping("<cmd>SearchReplaceWithinVisualSelection<cr>", "Replace within selection"),
    ["<C-b>"] = newMapping("<cmd>SearchReplaceWithinVisualSelectionCWord<cr>", "Replace within selection CWord"),
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- close buffer + hide terminal buffer
    ["<leader>X"] = newMapping(function() require("nvchad_ui.tabufline").closeOtherBufs() end, "Solo Buffer"),
  },
}

M.surround = {
  plugin = true,
  n = {
    ["gza"] = newMapping("gza", "Add surround"),
    ["gzd"] = newMapping("gzd", "Delete surround"),
    ["gzr"] = newMapping("gzr", "Replace surround"),
    ["gzf"] = newMapping("gzf", "Find surround"),
    ["gzF"] = newMapping("gzF", "Find surround left"),
    ["gzh"] = newMapping("gzh", "Highlight surround"),
    ["gzn"] = newMapping("gzn", "Update n_lines"),
  },
}

M.gitlinker = {
  n = {
    ["<leader>gy"] = newMapping( function() require("gitlinker").get_buf_range_url "n" end, "Get Repo Url"),
  },
}

M.todo = {
  n = {
    ["]t"] = newMapping(function() require("todo-comments").jump_next() end, "Next todo comment" ),
    ["[t"] = newMapping(function() require("todo-comments").jump_prev() end, "Previous todo comment" ),
    ["<leader>tx"] = newMapping( "<cmd>TodoTrouble<cr>", "Todo (Trouble)" ),
    ["<leader>tX"] = newMapping( "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme (Trouble)" ),
    ["<leader>ts"] = newMapping( "<cmd>TodoTelescope<cr>", "Todo" ),
    ["<leader>tS"] = newMapping( "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme" ),
  },
}

M.neoclip = {
  n = {
    ["<leader>fp"] = newMapping( "<cmd>Telescope neoclip theme=dropdown<cr>", "Clipboard" ),
  },
}

M.filemanager = {
  n = {
    ["<leader>d"] = newMapping( "<cmd>Lf<cr>", "File explorer" ),
  },
}

M.spectre = {
  n = {
    ["<leader>rr"] = {
      function()
        require("spectre").open()
      end,
      "Spectre",
    },
  },
}

M.project = {
  n = {
    ["<leader>oo"] = newMapping( "<cmd>Telescope projects<cr>", "Find Projects" ),
    ["<leader>oa"] = newMapping( "<cmd>AddProject<cr>", "Add Project" ),
    ["<leader>or"] = newMapping( "<cmd>ProjectRoot<cr>", "Root Project" ),
  },
}

M.grepliveargs = {
  n = {
    ["<leader>fg"] = {
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      "Live Grep Args",
    },
    ["<leader>fw"] = {
      function()
        require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
      end,
      "Live Grep under cursor",
    },
  },
  v = {
    ["<C-g>"] = {
      "<cmd>lua  require('telescope-live-grep-args.shortcuts').grep_visual_selection()<cr>",
      "Grep Selected",
    },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader><space>"] = newMapping( "<cmd> Telescope find_files <CR>", "Find files" ),
    ["<leader>fF"] = {
      "<cmd>lua require'telescope.builtin'.find_files({ cwd = vim.fn.expand('%:p:h') })<cr>",
      desc = "Find files in cwd",
    },
    ["<leader>b"] = newMapping( "<cmd> Telescope buffers <CR>", "Find buffers" ),
  },
}

-- more keybinds!

return M
