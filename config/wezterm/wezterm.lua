local wezterm = require 'wezterm'

return {
  -- Smart tab bar [distraction-free mode]
  hide_tab_bar_if_only_one_tab = true,

  check_for_updates = false,
  scrollback_lines = 9999,
  hide_tab_bar_if_only_one_tab = true,
  hyperlink_rules = {},
  window_close_confirmation = "NeverPrompt",
  adjust_window_size_when_changing_font_size = false,
  warn_about_missing_glyphs = false,

  color_scheme = "Catppuccin Mocha",


  -- window_background_opacity = 0.90,
  initial_cols = 150,
  initial_rows = 40,

  -- Font configuration
  -- https://wezfurlong.org/wezterm/config/fonts.html
  font = wezterm.font('JetBrains Mono'),
  font_size = 12.0,


}
