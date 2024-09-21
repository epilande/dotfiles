local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("DankMono Nerd Font Mono")
config.font_size = 16.0
config.line_height = 1.1

config.enable_tab_bar = false

-- config.window_background_opacity = 1
config.window_background_opacity = 0.95
config.macos_window_background_blur = 30

config.window_decorations = "RESIZE"

config.window_close_confirmation = "NeverPrompt"

config.window_padding = {
	left = 10,
	right = 8,
	top = 10,
	bottom = 0,
}

-- config.keys = {
-- 	{
-- 		key = "f",
-- 		mods = "CTRL",
-- 		action = wezterm.action.ToggleFullScreen,
-- 	},
-- }

config.mouse_bindings = {
	-- Cmd-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
