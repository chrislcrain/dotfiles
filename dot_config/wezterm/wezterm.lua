local wezterm = require("wezterm")

local config = wezterm.config_builder()

local ccpuccin = wezterm.color.get_builtin_schemes()["Catppuccin Macchiato"]
ccpuccin.background = "#000000"
ccpuccin.cursor_bg = "#00ffff"

config.font = wezterm.font("DankMono Nerd Font Mono", { weight = "Bold" })
config.font_size = 19.0
config.window_background_opacity = 0.85
config.macos_window_background_blur = 30
config.color_scheme = "Catppuccin Macchiato"
config.color_schemes = {
	-- ["Abernathy"] = ccpuccin,
	["Catppuccin Macchiato"] = ccpuccin,
}

-- Make inactive pane less visible
config.inactive_pane_hsb = {
	saturation = 0.7,
	brightness = 0.4,
}

-- Reduce padding
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Set FPS for smoothness
config.max_fps = 120

-- Use basic tab bar
config.use_fancy_tab_bar = false

-- Hide tab if only one
config.hide_tab_bar_if_only_one_tab = true

-- Hide title bar
config.window_decorations = "RESIZE"

-- MacOS full screen
config.native_macos_fullscreen_mode = true

-- Keys and mappings
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 800 }
config.keys = {
	-- More easy split key mappings
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendString("\x01") },

	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

	-- Full screen
	{ key = "Enter", mods = "OPT", action = wezterm.action.ToggleFullScreen },
}

-- Configure SSH domains
config.ssh_domains = wezterm.default_ssh_domains()
for _, dom in ipairs(config.ssh_domains) do
	dom.local_echo_threshold_ms = 10000
end

return config
