local wezterm = require 'wezterm'

local SOLID_LEFT_ARROW  = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

local COLORS = {
  inactive_bg  = "#5c6d74",
  active_bg    = "#ae8b2d",
  foreground   = "#FFFFFF",
  edge_bg      = "none",
}

local M = {}

function M.apply(config)
  -- タブが一つしかない時に非表示
  config.hide_tab_bar_if_only_one_tab = true

  -- タブバーの「+」「x」ボタンを非表示
  config.show_new_tab_button_in_tab_bar = false
  config.show_close_tab_button_in_tabs  = false

  config.colors = config.colors or {}
  config.colors.tab_bar = {
    inactive_tab_edge = "none",
  }
end

function M.setup_events()
  wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, max_width)
    local bg = tab.is_active and COLORS.active_bg or COLORS.inactive_bg
    local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

    return {
      { Background = { Color = COLORS.edge_bg } },
      { Foreground = { Color = bg } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = bg } },
      { Foreground = { Color = COLORS.foreground } },
      { Text = title },
      { Background = { Color = COLORS.edge_bg } },
      { Foreground = { Color = bg } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end)
end

return M
