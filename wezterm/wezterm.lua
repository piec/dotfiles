local wezterm = require 'wezterm'
--local config = {}
local config = wezterm.config_builder()
--config.font_dirs = { "/tmp/misc" }
--config.font = wezterm.font("Fixed", {stretch='SemiCondensed'})
--config.font = wezterm.font("/tmp/misc/6x13.pcf.gz")

--config.font_dirs = { "/usr/share/fonts/misc" }
config.font_dirs = { "/home/pierre/tmp/misc" }
--config.font = wezterm.font("Fixed", {stretch='SemiCondensed'})
--config.font = wezterm.font("Fixed SemiCondensed")
--config.font = wezterm.font("/usr/share/fonts/misc/6x13.pcf.gz")

config.font = wezterm.font_with_fallback {
    --"/tmp/misc/6x13.pcf.gz",
    --"/tmp/misc/6x13.pcf.gz",
    --"/usr/share/fonts/misc/6x13.pcf.gz",
    "Fixed",
    --"Misc Fixed",
    --"Misc Fixed Regular",
    --"Misc Fixed:style=SemiCondensed",
    --{family="Fixed", style="SemiCondensed"},
    --{family="Fixed", stretch="SemiCondensed"},
    --font,
    --{family="/usr/share/fonts/misc/6x13.pcf.gz"},
    --{family="Fixed",  weight="Regular", style="Normal"},
    --{family="Misc Fixed", stretch="SemiCondensed"},
    --"Terminus"
    "Noto Sans Mono"
}
config.font_size = 7

config.ssh_domains = {
  {
    -- This name identifies the domain
    name = 'carru.fr',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = 'carru.fr',
    -- The username to use on the remote host
    username = 'pierre',
  },
}

config.pane_focus_follows_mouse = true

-- timeout_milliseconds defaults to 1000 and can be omitted
--config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  --{
    --key = '|',
    --mods = 'LEADER|SHIFT',
    --action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  --},
  ---- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  --{
    --key = 'a',
    --mods = 'LEADER|CTRL',
    --action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
  --},

  {
    key = '%',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
    { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
    {
      key = 'B',
      mods = 'CTRL',
      action = wezterm.action.EmitEvent 'toggle-presentation',
    },
}

--config.window_decorations = "NONE"
config.enable_scroll_bar = true

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.color_scheme = "Pierre"

config.enable_tab_bar = true
config.window_frame = {
  font_size = 10,
}

config.selection_word_boundary = " \t\n{[}]()\"'`:;%/@.=,│"

wezterm.on('toggle-presentation', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if overrides.font_size ~= nil then
    overrides = {}
  else
    overrides.font = wezterm.font_with_fallback { "Noto Sans Mono" }
    overrides.font_size = 11
  end
  window:set_config_overrides(overrides)
end)

--config.canonicalize_pasted_newlines = "None"

--config.mouse_bindings = {
  --{
    --event = { Down = { streak = 3, button = 'Left' } },
    --action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    --mods = 'NONE',
  --},
--}

--term = "wezterm"

return config
