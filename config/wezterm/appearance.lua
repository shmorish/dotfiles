local wezterm = require 'wezterm'

local M = {}

function M.apply(config)
  -- Font
  config.font = wezterm.font_with_fallback({
    { family = "Hack Nerd Font Mono", weight = "Bold" },
    { family = "UDEV Gothic NF",      weight = "Bold" },
    { family = "Hiragino Sans",       weight = "DemiBold" },
    { family = "Symbols Nerd Font Mono" },
  })
  config.font_size = 15.0
  config.use_ime = true
  config.adjust_window_size_when_changing_font_size = false

  -- 不透明度
  config.window_background_opacity = 0.75
  config.macos_window_background_blur = 5

  -- タイトルバーを非表示
  config.window_decorations = "RESIZE"

  -- タブバーを背景と同じ色にする
  config.window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
  }
  config.window_background_gradient = {
    colors = { "#000000" },
  }
end

return M
