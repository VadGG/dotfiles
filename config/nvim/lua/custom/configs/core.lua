local M = {}

M.statusline = {
  -- theme = "vscode_colored",
  overriden_modules = function()
    local st_modules = require "nvchad_ui.statusline.default"
    local modes = st_modules.modes

    -- Load info for harpoon
    local function get_marked()
      local status_ok, Marked = pcall(require, "harpoon.mark")
      if not status_ok then
        return ""
      end

      local filename = vim.api.nvim_buf_get_name(0)
      local success, index = pcall(Marked.get_index_of, filename)
      if success and index and index ~= nil then
        return "󱡀 " .. index .. " "
      else
        return ""
      end
    end
    -- Load info for possession
    -- local function get_session()
    --   local session = require("nvim-possession").status()
    --   if session ~= nil then
    --     return "󰐃 "
    --   else
    --     return "󰐄 "
    --   end
    -- end

    return {

      -- St_NormalMode
      -- St_VisualMode
      -- St_InsertMode
      -- St_TerminalMode
      -- St_ReplaceMode
      mode = function()
        modes["n"][3] = "  "
        modes["v"][3] = "  "
        modes["i"][3] = "  "
        modes["t"][3] = "  "
        local m = vim.api.nvim_get_mode().mode
        return "%#" .. modes[m][2] .. "#" .. (modes[m][3] or "  ") .. modes[m][1] .. " "
      end,
      fileInfo = function()
        local icon = " 󰈚 "
        local fname = vim.fn.expand "%:t"
        local filename = vim.fn.expand "%:~:."
        local icon_text

        if fname ~= "Empty " then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon, ft_icon_hl = devicons.get_icon(fname, string.match(fname, "%a+$"))
            icon = (ft_icon ~= nil and " " .. ft_icon) or ""
            local icon_hl = ft_icon_hl or "DevIconDefault"
            local hl_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(icon_hl)), "fg")
            local hl_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "StText"), "bg")
            vim.api.nvim_set_hl(0, "St_" .. icon_hl, { fg = hl_fg, bg = hl_bg })
            icon_text = "%#St_" .. icon_hl .. "# " .. icon .. "%#StText# " .. get_marked() .. filename .. " "
          end
        end

        return icon_text or ("%#StText# " .. icon .. get_marked() .. filename)
      end,

      -- LSP_status = function()
      --   if rawget(vim, "lsp") then
      --     for _, client in ipairs(vim.lsp.get_active_clients()) do
      --       if client.attached_buffers[vim.api.nvim_get_current_buf()] and (client.name ~= "null-ls" and client.name ~= "copilot") then
      --         return (vim.o.columns > 100 and "%#St_LspStatus#   " .. client.name) or "   LSP"
      --       end
      --     end
      --   end
      -- end,
      --
      -- LSP_Diagnostics = function()
      --   return "%#CopilotHl#"
      --     .. require("copilot_status").status_string()
      --     .. " "
      --     .. "%#HarpoonHl#"
      --     .. get_marked()
      --     .. "%#BatteryHl#"
      --     .. require("battery").get_status_line()
      --     .. " "
      --     -- .. "%#SessionHl#"
      --     -- .. get_session()
      --     -- .. " "
      --     .. st_modules.LSP_Diagnostics()
      -- end,

      cwd = function()
        return " %#TermHl#%@v:lua.ClickTerm@ " .. " %#NotificationHl#%@v:lua.ClickMe@  " .. st_modules.cwd()
      end,
    }
  end,
}

return M
