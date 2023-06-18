local status_ok, lf = pcall(require, "lf")
if not status_ok then
  return
end

lf.setup({
        escape_quit = false,
        border = "rounded",
        -- highlights = {FloatBorder = {guifg = require("kimbox.palette").colors.magenta}}
        default_action = "edit", -- default action when `Lf` opens a file
        default_actions = { -- default action keybindings
          ["<C-t>"] = "tabedit",
          ["<C-x>"] = "split",
          ["<C-v>"] = "vsplit",
          ["<C-o>"] = "tab drop",
        },
})

