local wezterm = require 'wezterm'
local mux     = wezterm.mux

local config = wezterm.config_builder and wezterm.config_builder() or {}

config.automatically_reload_config = true

require('appearance').apply(config)
require('tabs').apply(config)
require('tabs').setup_events()

-- ペイン分割の境界線の色
config.colors       = config.colors or {}
config.colors.split = '#AAAAAA'

-- 画面の最大化（起動時）
wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

config.keys = require 'keybinds'

return config
