return {
  "ThePrimeagen/harpoon",
  dependencies = "nvim-lua/plenary.nvim",
  opts = {
    global_settings = { mark_branch = true },
    width = vim.api.nvim_win_get_width(0) - 4,
  },
  keys = {
    {
      "<leader>'",
      "<cmd>lua require('harpoon.mark').add_file(); print('Added to Harpoon')<cr>",
      desc = "Add to harpoon",
    },
    { "<leader>0", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Show Harpoon" },
    { "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "Harpoon Buffer 1" },
    { "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "Harpoon Buffer 2" },
    { "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "Harpoon Buffer 3" },
  },
}
