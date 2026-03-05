local wezterm = require 'wezterm'
local act = wezterm.action
local act_callback = wezterm.action_callback

return {
  -- Option + a : 画面の最大化
  { key = 'a', mods = 'OPT', action = act_callback(function(window, _pane)
    window:maximize()
  end) },

  -- Cmd + d : 左右分割
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- Cmd + Shift + d : 上下分割
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Cmd + Option + → / ← : 右/左のTabへ
  { key = 'RightArrow', mods = 'CMD|OPT', action = act.ActivateTabRelative(1) },
  { key = 'LeftArrow',  mods = 'CMD|OPT', action = act.ActivateTabRelative(-1) },

  -- Option + ←↓↑→ : ペイン移動
  { key = 'LeftArrow',  mods = 'OPT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'OPT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'OPT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'OPT', action = act.ActivatePaneDirection 'Down' },

  -- Cmd + + / - : フォント拡大・縮小（配列差対策で '=' も）
  { key = '=', mods = 'CMD', action = act.IncreaseFontSize },
  { key = '+', mods = 'CMD', action = act.IncreaseFontSize },
  { key = '-', mods = 'CMD', action = act.DecreaseFontSize },
  { key = '_', mods = 'CMD', action = act.DecreaseFontSize },
}
