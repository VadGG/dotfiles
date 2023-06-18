local status_ok, pconfig = pcall(require, "nvim-peekup.config")
if not status_ok then
  return
end

pconfig.on_keystroke["delay"] = '20ms'
pconfig.on_keystroke["paste_reg"] = '"'



