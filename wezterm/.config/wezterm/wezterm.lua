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

config.keys = {
	{
		key = "P",
		mods = "CMD|SHIFT",
		action = wezterm.action.ActivateCommandPalette,
	},

	-- Tmux
	{
		key = "t",
		mods = "CMD",
		action = wezterm.action.SendString("\x01c"),
	},
	{
		key = "x",
		mods = "CMD",
		action = wezterm.action.SendString("\x01x"),
	},
	{ key = "1", mods = "CMD", action = wezterm.action({ SendString = "\x011" }) },
	{ key = "2", mods = "CMD", action = wezterm.action({ SendString = "\x012" }) },
	{ key = "3", mods = "CMD", action = wezterm.action({ SendString = "\x013" }) },
	{ key = "4", mods = "CMD", action = wezterm.action({ SendString = "\x014" }) },
	{ key = "5", mods = "CMD", action = wezterm.action({ SendString = "\x015" }) },
	{ key = "6", mods = "CMD", action = wezterm.action({ SendString = "\x016" }) },
	{ key = "7", mods = "CMD", action = wezterm.action({ SendString = "\x017" }) },
	{ key = "8", mods = "CMD", action = wezterm.action({ SendString = "\x018" }) },
	{ key = "9", mods = "CMD", action = wezterm.action({ SendString = "\x019" }) },
	-- { key = "0", mods = "CMD", action = wezterm.action({ SendString = "\x010" }) },
}

config.mouse_bindings = {
	-- Cmd-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
