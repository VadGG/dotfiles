return {
  {
    "ruifm/gitlinker.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  keys = {
    {
      "<leader>ff",
      "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({previewer = false}))<cr>",
      desc = "Files",
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
    { "<leader>fp", "<cmd>Telescope neoclip theme=dropdown<cr>", desc = "Clipboard" },
  },
}
