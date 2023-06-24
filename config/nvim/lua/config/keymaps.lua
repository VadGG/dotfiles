-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local term_opts = { silent = true }

local function keymap(mode, new_key, action, desc)
  local k = vim.api.nvim_set_keymap
  k(mode, new_key, action, { noremap = true, silent = true, desc = desc })
end

keymap("v", "L", "$", "Jump End of line")
keymap("v", "H", "^", "Jump begining of line")

keymap("n", "<C-h>", "<cmd> TmuxNavigateLeft<cr>", "Go Right window")
keymap("n", "<C-l>", "<cmd> TmuxNavigateRight<cr>", "Go left window")
keymap("n", "<C-j>", "<cmd> TmuxNavigateDown<cr>", "Go below window")
keymap("n", "<C-k>", "<cmd> TmuxNavigateUp<cr>", "Go above window")

-- keymap("n", "<C-Up>", ":resize -10<cr>", "Size window up")
-- keymap("n", "<C-Down>", ":resize +10<cr>", "Size window down")
-- keymap("n", "<C-Right>", ":vertical resize -10<cr>", "Size window right")
-- keymap("n", "<C-Left>", ":vertical resize +10<cr>", "Size window left")

keymap("n", "<C-x>", "<cmd>lua require('mini.bufremove').delete(0, true) <cr>", "Delete current buffer")
keymap(
  "v",
  "<C-g>",
  "<cmd>lua require('telescope-live-grep-args.shortcuts').grep_visual_selection()<cr>",
  "Grep highlighted word"
)

function _SET_CLIPBOARD(clip_value)
  local current_clip_value = vim.api.nvim_exec("set clipboard?", true)
  local current_value = string.match(current_clip_value, "=(.+)")
  if current_value == clip_value then
    clip_value = ""
  end
  vim.cmd("set clipboard=" .. clip_value)
  vim.cmd("set clipboard?")
end

keymap("n", "`", "<cmd>lua _SET_CLIPBOARD('unnamedplus')<cr>", "Toggle clipboard")
keymap("v", "`", "<cmd>lua _SET_CLIPBOARD('unnamedplus')<cr>", "Toggle clipboard")
