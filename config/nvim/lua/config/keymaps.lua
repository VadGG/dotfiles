-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("v", "L", "$", opts)
keymap("v", "H", "^", opts)

keymap("n", "<C-h>", "<cmd> TmuxNavigateLeft<cr>", opts)
keymap("n", "<C-l>", "<cmd> TmuxNavigateRight<cr>", opts)
keymap("n", "<C-j>", "<cmd> TmuxNavigateDown<cr>", opts)
keymap("n", "<C-k>", "<cmd> TmuxNavigateUp<cr>", opts)

keymap("n", "<C-Up>", ":resize -10<cr>", opts)
keymap("n", "<C-Down>", ":resize +10<cr>", opts)
keymap("n", "<C-Right>", ":vertical resize -10<cr>", opts)
keymap("n", "<C-Left>", ":vertical resize +10<cr>", opts)

keymap("n", "<C-x>", "<cmd>lua MiniBufremove.delete()<cr>", opts)
keymap("v", "<C-g>", "<cmd>lua require('telescope-live-grep-args.shortcuts').grep_visual_selection()<cr>", opts)

function _SET_CLIPBOARD(clip_value)
  local current_clip_value = vim.api.nvim_exec("set clipboard?", true)
  local current_value = string.match(current_clip_value, "=(.+)")
  if current_value == clip_value then
    clip_value = ""
  end
  vim.cmd("set clipboard=" .. clip_value)
  vim.cmd("set clipboard?")
end

keymap("n", "`", "<cmd>lua _SET_CLIPBOARD('unnamedplus')<cr>", opts)
keymap("v", "`", "<cmd>lua _SET_CLIPBOARD('unnamedplus')<cr>", opts)
