local wezterm = require("wezterm")
local utils = require("utils")
local keybinds = require("keybinds")
local scheme = wezterm.get_builtin_color_schemes()["nord"]

local gpus = wezterm.gui.enumerate_gpus()
local rose_pine_theme = require('plugins/rose-pine').main


require("on")

-- /etc/ssh/sshd_config
-- AcceptEnv TERM_PROGRAM_VERSION COLORTERM TERM TERM_PROGRAM WEZTERM_REMOTE_PANE
-- sudo systemctl reload sshd

---------------------------------------------------------------
--- functions
---------------------------------------------------------------
-- selene: allow(unused_variable)
---@diagnostic disable-next-line: unused-function, unused-local
local function enable_wayland()
	local wayland = os.getenv("XDG_SESSION_TYPE")
	if wayland == "wayland" then
		return true
	end
	return false
end

---------------------------------------------------------------
--- Merge the Config
---------------------------------------------------------------
local function create_ssh_domain_from_ssh_config(ssh_domains)
	if ssh_domains == nil then
		ssh_domains = {}
	end
	for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
		table.insert(ssh_domains, {
			name = host,
			remote_address = config.hostname .. ":" .. config.port,
			username = config.user,
			multiplexing = "None",
			assume_shell = "Posix",
		})
	end
	return { ssh_domains = ssh_domains }
end

--- load local_config
-- Write settings you don't want to make public, such as ssh_domains
package.path = os.getenv("HOME") .. "/.local/share/wezterm/?.lua;" .. package.path
local function load_local_config(module)
	local m = package.searchpath(module, package.path)
	if m == nil then
		return {}
	end
	return dofile(m)
	-- local ok, _ = pcall(require, "local")
	-- if not ok then
	-- 	return {}
	-- end
	-- return require("local")
end

local local_config = load_local_config("local")

-- local local_config = {
-- 	ssh_domains = {
-- 		{
-- 			-- This name identifies the domain
-- 			name = "my.server",
-- 			-- The address to connect to
-- 			remote_address = "192.168.8.31",
-- 			-- The username to use on the remote host
-- 			username = "katayama",
-- 		},
-- 	},
-- }
-- return local_config

---------------------------------------------------------------
--- Config
---------------------------------------------------------------
local config = {
	font = wezterm.font("Hack Nerd Font Mono", {
	  weight="Regular",
	  stretch="Normal",
	  style="Normal"
	}),
	-- font_size = 10.0,
	-- font = wezterm.font("UDEV Gothic 35NFLG"),
	font_size = 14,
	-- cell_width = 1.1,
	-- line_height = 1.1,
	-- font_rules = {
	-- 	{
	-- 		italic = true,
	-- 		font = wezterm.font("Cica", { italic = true }),
	-- 	},
	-- 	{
	-- 		italic = true,
	-- 		intensity = "Bold",
	-- 		font = wezterm.font("Cica", { weight = "Bold", italic = true }),
	-- 	},
	-- },
	check_for_updates = false,
	use_ime = true,
	-- ime_preedit_rendering = "System",
	use_dead_keys = false,
	warn_about_missing_glyphs = false,
	-- enable_kitty_graphics = false,
	animation_fps = 1,
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	cursor_blink_rate = 0,
	-- enable_wayland = enable_wayland(),
	-- https://github.com/wez/wezterm/issues/1772
	enable_wayland = false,


	hide_tab_bar_if_only_one_tab = false,
	adjust_window_size_when_changing_font_size = false,
	selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",
	-- window_decorations = "NONE",

	window_padding = {
		left = 20,
		right = 20,
		top = 10,
		bottom = 10,
	},

	use_fancy_tab_bar = false,

	colors = rose_pine_theme.colors(),
	window_frame = rose_pine_theme.window_frame(),

	-- color_scheme_dirs = { "~/.config/wezterm/colors/" },
	-- color_scheme = "sunset",

	-- colors = {
	-- 	selection_fg = '#353D4D',
	-- 	selection_bg = '#FFE6CB',
	-- 	foreground = "#C7D4ED",
	-- 	background = "#1C2026",
	-- 	tab_bar = {
	-- 		background = scheme.background,
	-- 		new_tab = { bg_color = "#2e3440", fg_color = scheme.ansi[8], intensity = "Bold" },
	-- 		new_tab_hover = { bg_color = scheme.ansi[1], fg_color = scheme.brights[8], intensity = "Bold" },
	-- 		-- format-tab-title
	-- 		-- active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
	-- 		-- inactive_tab = { bg_color = scheme.background, fg_color = "#FCE8C3" },
	-- 		-- inactive_tab_hover = { bg_color = scheme.ansi[1], fg_color = "#FCE8C3" },
	-- 	},
	-- },

	exit_behavior = "CloseOnCleanExit",
	tab_bar_at_bottom = false,
	window_close_confirmation = "AlwaysPrompt",
	-- window_background_opacity = 0.8,
	disable_default_key_bindings = true,
	-- visual_bell = {
	-- 	fade_in_function = "EaseIn",
	-- 	fade_in_duration_ms = 150,
	-- 	fade_out_function = "EaseOut",
	-- 	fade_out_duration_ms = 150,
	-- },
	-- separate <Tab> <C-i>
	enable_csi_u_key_encoding = true,
	leader = { key = "Space", mods = "CTRL|SHIFT" },
	keys = keybinds.create_keybinds(),

	key_tables = keybinds.key_tables,
	mouse_bindings = keybinds.mouse_bindings,
	-- https://github.com/wez/wezterm/issues/2756
	webgpu_preferred_adapter = gpus[1],
	front_end = "OpenGL",
}

wezterm.log_info("Initializing keybinds" )
wezterm.log_info(wezterm.GLOBAL.mode)

for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.backend == "Vulkan" and gpu.device_type == "IntegratedGpu" then
		config.webgpu_preferred_adapter = gpu
		config.front_end = "WebGpu"
		break
	end
end

config.quick_select_patterns = {
    -- "[0-9a-f]{7,40}", -- SHA1 hashes, usually used for Git.
    -- "[0-9a-f]{7,64}", -- SHA256 hashes, used often for getting hashes for Guix packaging.
    -- "sha256-.{44,128}", -- SHA256 hashes in Base64, used often in getting hashes for Nix packaging.
    "[a-zA-Z0-9-_\\.]*(?<!:-)(?:-[a-zA-Z0-9-_\\.]+)+-?"
}

config.hyperlink_rules = {
	-- Matches: a URL in parens: (URL)
	{
		regex = '\\((\\w+://\\S+)\\)',
		format = '$1',
		highlight = 1,
	},
	-- Matches: a URL in brackets: [URL]
	{
		regex = '\\[(\\w+://\\S+)\\]',
		format = '$1',
		highlight = 1,
	},
	-- Matches: a URL in curly braces: {URL}
	{
		regex = '\\{(\\w+://\\S+)\\}',
		format = '$1',
		highlight = 1,
	},
	-- Matches: a URL in angle brackets: <URL>
	{
		regex = '<(\\w+://\\S+)>',
		format = '$1',
		highlight = 1,
	},
	-- Then handle URLs not wrapped in brackets
	{
		-- Before
		--regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
		--format = '$0',
		-- After
		regex = '[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)',
		format = '$1',
		highlight = 1,
	},
	-- implicit mailto link
	{
		regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
		format = 'mailto:$0',
	},
}
table.insert(config.hyperlink_rules, {
	regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
	format = "https://github.com/$1/$3",
})


local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

local bar_config = {
  position = "top",
  max_width = 32,
  padding = {
    left = 1,
    right = 1,
  },
  separator = {
    space = 1,
    left_icon = wezterm.nerdfonts.fa_long_arrow_right,
    right_icon = wezterm.nerdfonts.fa_long_arrow_left,
    field_icon = wezterm.nerdfonts.indent_line,
  },
  modules = {
    tabs = {
      active_tab_fg = 4,
      inactive_tab_fg = 6,
    },
    workspace = {
      enabled = false,
      icon = wezterm.nerdfonts.cod_window,
      color = 8,
    },
    leader = {
      enabled = false,
      icon = wezterm.nerdfonts.oct_rocket,
      color = 2,
    },
    pane = {
      enabled = true,
      icon = wezterm.nerdfonts.cod_multiple_windows,
      color = 7,
    },
    username = {
      enabled = true,
      icon = wezterm.nerdfonts.fa_user,
      color = 6,
    },
    hostname = {
      enabled = true,
      icon = wezterm.nerdfonts.cod_server,
      color = 8,
    },
    clock = {
      enabled = true,
      icon = wezterm.nerdfonts.md_calendar_clock,
      color = 5,
    },
    cwd = {
      enabled = true,
      icon = wezterm.nerdfonts.oct_file_directory,
      color = 7,
    },
    spotify = {
      enabled = false,
    },
  },
}

bar.apply_to_config(bar_config)


local merged_config = utils.merge_tables(config, local_config)
return utils.merge_tables(merged_config, create_ssh_domain_from_ssh_config(merged_config.ssh_domains))
