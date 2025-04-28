local wezterm = require("wezterm")

-- Integration with neovim panes
local function isViProcess(pane)
	-- get_foreground_process_name On Linux, macOS and Windows,
	-- the process can be queried to determine this path. Other operating systems
	-- (notably, FreeBSD and other unix systems) are not currently supported
	-- return pane:get_foreground_process_name():find('n?vim') ~= nil
	-- Use get_title as it works for multiplexed sessions too
	return pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
	local vim_pane_changed = false

	if isViProcess(pane) then
		local before = pane:get_cursor_position()
		window:perform_action(
			-- This should match the keybinds you set in Neovim.
			wezterm.action.SendKey({ key = vim_direction, mods = "CTRL" }),
			pane
		)
		wezterm.sleep_ms(50)
		local after = pane:get_cursor_position()

		if before.x ~= after.x and before.y ~= after.y then
			vim_pane_changed = true
		end
	end

	if not vim_pane_changed then
		window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
	end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
	conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
	conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
	conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
	conditionalActivatePane(window, pane, "Down", "j")
end)

local config = wezterm.config_builder()

local ccpuccin = wezterm.color.get_builtin_schemes()["Catppuccin Macchiato"]
ccpuccin.background = "#000000"
ccpuccin.cursor_bg = "#00ffff"

config.font = wezterm.font("DankMono Nerd Font Mono", { weight = "Bold" })
config.font_size = 16.0
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
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 800 }
config.keys = {
	-- More easy split key mappings
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendString("\x01") },

	-- Integration with neovim panes
	{ key = "h", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
	{ key = "j", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
	{ key = "k", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
	{ key = "l", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },
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
