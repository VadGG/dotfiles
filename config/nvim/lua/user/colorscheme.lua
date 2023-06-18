-- local colorscheme = "everforest"
--
-- local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
-- if not status_ok then
--   return
-- end

local status_ok, theme = pcall(require, "onenord")
if not status_ok then
  return
end

theme.setup()

