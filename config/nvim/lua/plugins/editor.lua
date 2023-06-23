return {
  -- easily jump to any location and enhanced f/t motions for Leap
  {
    "ggandor/flit.nvim",
    enabled = false,
  },
  {
    "ggandor/leap.nvim",
    enabled = false,
  },

  {
    "chrisgrieser/nvim-recorder",
    opts = {},
  },
  {
    "gennaro-tedesco/nvim-peekup",
    config = function()
      local config = require("nvim-peekup.config")
      config.on_keystroke["delay"] = "20ms"
      config.on_keystroke["paste_reg"] = '"'
    end,
    opts = {},
  },

  {
    "ggandor/lightspeed.nvim",
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
  },
}
