local wezterm = require 'wezterm'
local act = wezterm.action
local act_callback = wezterm.action_callback

return {
  -- Cmd + h : 左半分にスナップ
  { key = 'h', mods = 'CMD', action = act_callback(function(window, _pane)
    local screens = wezterm.gui.screens()
    local screen = screens.active
    local half_w = math.floor(screen.width / 2)
    window:set_position(0, 0)
    window:set_inner_size(half_w, screen.height)
  end) },

  -- Cmd + l : 右半分にスナップ
  { key = 'l', mods = 'CMD', action = act_callback(function(window, _pane)
    local screens = wezterm.gui.screens()
    local screen = screens.active
    local half_w = math.floor(screen.width / 2)
    window:set_position(half_w, 0)
    window:set_inner_size(half_w, screen.height)
  end) },

  -- Cmd + a : 画面の最大化
  { key = 'a', mods = 'CMD', action = act_callback(function(window, _pane)
    window:maximize()
  end) },

  -- ペイン分割・移動・タブ切替・リサイズは herdr に移譲
  -- Cmd系はTUIに届かないため、herdrのキーに変換して送信する
  -- (herdr/.config/herdr/config.toml の [keys] を参照)

  -- Cmd + d : 左右分割 (herdrの alt+d)
  { key = 'd', mods = 'CMD', action = act.SendString '\x1bd' },

  -- Cmd + Shift + d : 上下分割 (herdrの alt+shift+d)
  { key = 'd', mods = 'CMD|SHIFT', action = act.SendString '\x1bD' },

  -- Cmd + Option + l / h : 右/左のタブへ (herdrの ctrl+alt+l / ctrl+alt+h)
  { key = 'l', mods = 'CMD|OPT', action = act.SendString '\x1b\x0c' },
  { key = 'h', mods = 'CMD|OPT', action = act.SendString '\x1b\x08' },

  -- Cmd + + / - : フォント拡大・縮小
  { key = '+', mods = 'CMD', action = act.IncreaseFontSize },
  { key = '-', mods = 'CMD', action = act.DecreaseFontSize },
}
