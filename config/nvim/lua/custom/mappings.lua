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

    ["<C-r>"] = { "<cmd>SearchReplaceSingleBufferVisualSelection<cr>", "Replace selected", opts = { nowait = true } },
    ["<C-s>"] = { "<cmd>SearchReplaceWithinVisualSelection<cr>", "Replace within selection", opts = { nowait = true } },
    ["<C-b>"] = { "<cmd>SearchReplaceWithinVisualSelectionCWord<cr>", "Replace within selection CWord", opts = { nowait = true } },
    ["<C-g>"] = { "<cmd>lua  require('telescope-live-grep-args.shortcuts').grep_visual_selection()<cr>", "Grep Selected", opts = { nowait = true } },
    ["`"] = {
      function()
        _SET_CLIPBOARD('unnamedplus')
      end,
      "Toggle clipboard",
    },
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
      "Solo Buffe",
    },
  },
}

-- more keybinds!

return M
