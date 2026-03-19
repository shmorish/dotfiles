local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = wezterm.config_builder and wezterm.config_builder() or {}

-- 自動リロード
config.automatically_reload_config = true

-- Font設定
config.font = wezterm.font_with_fallback({
  { family = "Hack Nerd Font Mono", weight = "Bold" },
  { family = "UDEV Gothic NF", weight = "Bold" },
  { family = "Hiragino Sans", weight = "DemiBold" },
  { family = "Symbols Nerd Font Mono" },
})
config.font_size = 15.0
config.use_ime = true

-- 不透明度
config.window_background_opacity = 0.75
config.macos_window_background_blur = 20

-- タイトルバーを非表示
config.window_decorations = "RESIZE"

-- タブが一つしかない時に非表示
config.hide_tab_bar_if_only_one_tab = true

-- タブバーを背景と同じ色にする
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.window_background_gradient = {
  colors = { "#000000" },
}

-- タブバーの「+」,「x」ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

-- タブのタイトルをカスタマイズ
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"

  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background

  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

-- 画面の最大化（起動時）
wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

-- フォントサイズ変更時にウィンドウサイズは変更しない
config.adjust_window_size_when_changing_font_size = false

-- ペイン分割の境界線の色
config.colors = config.colors or {}
config.colors.split = '#AAAAAA'

-- Keybinds（別ファイル）
config.keys = require 'keybinds'

return config
