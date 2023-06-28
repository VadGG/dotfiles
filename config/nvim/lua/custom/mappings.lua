---@type MappingsTable
local M = {}

function _SET_CLIPBOARD(clip_value)
  local current_clip_value = vim.api.nvim_exec("set clipboard?", true)
  local current_value = string.match(current_clip_value, "=(.+)")
  if current_value == clip_value then
    clip_value = ""
  end
  vim.cmd("set clipboard=" .. clip_value)
  vim.cmd("set clipboard?")
end

local function newMapping(shortcut, desc) 
  return { shortcut, desc, opts = { nowait = true } }
end

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["H"] = { "^", "Begining of line", opts = { nowait = true } },
    ["L"] = { "$", "End of line", opts = { nowait = true } },

    ["<leader>\\"] = { "<cmd>vs<CR>", "Vertical split" },
    ["<leader>-"] = { "<cmd>sp<CR>", "Horizontal split" },
    ["<leader>wq"] = { "<cmd>q<CR>", "Close Window" },

    ["<C-Up>"] = { "<cmd>resize -10<cr>", "Resize Screen Up" },
    ["<C-Down>"] = { "<cmd>resize +10<cr>", "Resize Screen Down" },
    ["<C-Left>"] = { "<cmd>vertical resize -10<cr>", "Resize Screen Left" },
    ["<C-Right>"] = { "<cmd>vertical resize +10<cr>", "Resize Screen Right" },

    ["<C-h>"] = { "<cmd> TmuxNavigateLeft<cr>", "Move left" },
    ["<C-l>"] = { "<cmd> TmuxNavigateRight<cr>", "Move right" },
    ["<C-j>"] = { "<cmd> TmuxNavigateDown<cr>", "Move down" },
    ["<C-k>"] = { "<cmd> TmuxNavigateUp<cr>", "Move up" },
    
    ["`"] = {
      function()
        _SET_CLIPBOARD('unnamedplus')
      end,
      "Toggle clipboard",
    },
  },
  v = {
    ["H"] = { "^", "Begining of line", opts = { nowait = true } },
    ["L"] = { "$", "End of line", opts = { nowait = true } },

    ["<"] = { "<gv", "Indent left"  },
    [">"] = { ">gv", "Indent Right"  },
    
    ["<leader>\\"] = { "<cmd>vs<CR>", "Vertical split" },
    ["<leader>-"] = { "<cmd>sp<CR>", "Horizontal split" },
    ["<leader>wq"] = { "<cmd>q<CR>", "Close Window" },
    
    ["<C-h>"] = { "<cmd> TmuxNavigateLeft<cr>", "Move left" },
    ["<C-l>"] = { "<cmd> TmuxNavigateRight<cr>", "Move right" },
    ["<C-j>"] = { "<cmd> TmuxNavigateDown<cr>", "Move down" },
    ["<C-k>"] = { "<cmd> TmuxNavigateUp<cr>", "Move up" },
  
    ["<C-Up>"] = { "<cmd>resize -10<cr>", "Resize Screen Up" },
    ["<C-Down>"] = { "<cmd>resize +10<cr>", "Resize Screen Down" },
    ["<C-Left>"] = { "<cmd>vertical resize -10<cr>", "Resize Screen Left" },
    ["<C-Right>"] = { "<cmd>vertical resize +10<cr>", "Resize Screen Right" },

    ["<C-g>"] = { "<cmd>lua  require('telescope-live-grep-args.shortcuts').grep_visual_selection()<cr>", "Grep Selected", opts = { nowait = true } },
    ["`"] = {
      function()
        _SET_CLIPBOARD('unnamedplus')
      end,
      "Toggle clipboard",
    },
  }
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
  }
}

M.tabufline = {
  plugin = true,

  n = {
    -- close buffer + hide terminal buffer
    ["<leader>X"] = {
      function()
        require("nvchad_ui.tabufline").closeOtherBufs()
      end,
      "Solo Buffer",
    },
  },
}

M.surround = {
  plugin = true,

  -- n = {
  --   
  --   ["gza"] = newMapping("gza", "Add surround"),
  --   ["gzd"] = newMapping("gzd", "Delete surround"),
  --   ["gzr"] = newMapping("gzr", "Replace surround"),
  --   ["gzf"] = newMapping("gzf", "Find surround"),
  --   ["gzF"] = newMapping("gzF", "Find surround left"),
  --   ["gzh"] = newMapping("gzh", "Highlight surround"),
  --   ["gzn"] = newMapping("gzn", "Update n_lines"),
  --
  -- }
}

M.gitlinker = {
  n = {
     ["<leader>gy"] = { function() require("gitlinker").get_buf_range_url("n") end, "Get Repo Url" },
  }
}

M.todo = {
  n = {
      ["]t"] = { function() require("todo-comments").jump_next() end, "Next todo comment" },
      ["[t"] = {  function() require("todo-comments").jump_prev() end, "Previous todo comment" },
      ["<leader>tx"] = { "<cmd>TodoTrouble<cr>", "Todo (Trouble)" },
      ["<leader>tX"] = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme (Trouble)" },
      ["<leader>ts"] = { "<cmd>TodoTelescope<cr>", "Todo" },
      ["<leader>tS"] = { "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme" },
  }
}


M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader><space>"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>fF"] ={
        "<cmd>lua require'telescope.builtin'.find_files({ cwd = vim.fn.expand('%:p:h') })<cr>",
        desc = "Find files in cwd",
      },
  },
}


-- more keybinds!

return M
