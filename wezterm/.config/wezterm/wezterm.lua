local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Font設定
config.font = wezterm.font_with_fallback({
  { family = "Hack Nerd Font Mono", weight = "Bold" },
  { family = "UDEV Gothic NF", weight = "Bold" },
  { family = "Hiragino Sans", weight = "DemiBold" },
  { family = "Symbols Nerd Font Mono" },
})
config.font_size = 15
config.use_ime = true

-- 自動リロード
config.automatically_reload_config = true

-- 不透明度
config.window_background_opacity = 0.75

-- 画面の最大化（起動時）
wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

-- フォントサイズ変更時にウィンドウサイズは変更しない
config.adjust_window_size_when_changing_font_size = false

-- タブバーの「+」を削除
config.show_new_tab_button_in_tab_bar = false

-- ペイン分割の境界線の色
config.colors = config.colors or {}
config.colors.split = '#AAAAAA'

-- Keybinds（別ファイル）
config.keys = require 'keybinds'

return config
