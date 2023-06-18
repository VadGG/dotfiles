local status_ok, miniplugin = pcall(require, "mini.bufremove")
if not status_ok then
  return
end

miniplugin.setup ({
  -- Whether two set Vim's settings for buffers (allow hidden buffers)
  set_vim_settings = true,

  -- Whether to disable showing non-error feedback
  silent = false,
})


