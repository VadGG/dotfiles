return {
  {
    "roobert/search-replace.nvim",
    config = function()
      require("search-replace").setup({
        -- optionally override defaults
        default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      })
    end,
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

    keys = {
      {
        "<leader>rs",
        "<CMD>SearchReplaceSingleBufferSelections<CR>",
        desc = "SearchReplaceSingleBuffer [s]elction list",
      },
      { "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", desc = "[o]pen" },
      { "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", desc = "[w]ord" },
      { "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", desc = "[W]ord" },
      { "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", desc = "[e]xpr" },
      { "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", desc = "[f]ile" },

      {
        "<leader>rbs",
        "<CMD>SearchReplaceMultiBufferSelections<CR>",
        desc = "SearchReplaceMultiBuffer [s]elction list",
      },
      { "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", desc = "[o]pen" },
      { "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", desc = "[w]ord" },
      { "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", desc = "[W]ord" },
      { "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", desc = "[e]xpr" },
      { "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", desc = "[f]ile" },
    },
  },
  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>rr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },
}
