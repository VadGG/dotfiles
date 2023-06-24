---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["H"] = { "^", "Begining of line", opts = { nowait = true } },
    ["L"] = { "$", "End of line", opts = { nowait = true } },
  },
  v = {
    ["H"] = { "^", "Begining of line", opts = { nowait = true } },
    ["L"] = { "$", "End of line", opts = { nowait = true } },
  }
}

-- more keybinds!

return M
