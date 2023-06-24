return {
  {
    "nvim-treesitter/nvim-treesitter",

    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        -- "html",
        -- "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        -- "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        -- "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
}
