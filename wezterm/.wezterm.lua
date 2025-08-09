local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

config.font = wezterm.font("JetBrainsMono NF")
config.font_size = 16
config.color_scheme = "Catppuccin Mocha"

return config
