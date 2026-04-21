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

  -- Cmd + d : 左右分割
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- Cmd + Shift + d : 上下分割
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Cmd + Option + l / h : 右/左のTabへ
  { key = 'l', mods = 'CMD|OPT', action = act.ActivateTabRelative(1) },
  { key = 'h', mods = 'CMD|OPT', action = act.ActivateTabRelative(-1) },

  -- Option + hjkl : ペイン移動
  { key = 'h', mods = 'OPT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'OPT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'OPT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'OPT', action = act.ActivatePaneDirection 'Down' },

  -- Cmd + + / - : フォント拡大・縮小
  { key = '+', mods = 'CMD', action = act.IncreaseFontSize },
  { key = '-', mods = 'CMD', action = act.DecreaseFontSize },

  -- Cmd + Shift + hjkl : ペインサイズ変更
  { key = 'h', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'l', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'k', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'j', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
}
