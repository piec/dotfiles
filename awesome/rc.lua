-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
-- Do not register service on dbus so that I can use dunst
-- see https://github.com/awesomeWM/awesome/issues/1285
local _dbus = dbus; dbus = nil
local naughty = require("naughty")
dbus = _dbus

--local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local vicious = require("vicious")
local cyclefocus = require('cyclefocus')
cyclefocus.move_mouse_pointer = false

local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

--local mylog = io.open(os.getenv("HOME") .. "/tmp/awesome_log", "a")
--mylog:write("bla\n")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
--if awesome.startup_errors then
    --naughty.notify({ preset = naughty.config.presets.critical,
                     --title = "Oops, there were errors during startup!",
                     --text = awesome.startup_errors })
--end

-- Handle runtime errors after startup
--do
    --local in_error = false
    --awesome.connect_signal("debug::error", function (err)
        ---- Make sure we don't go into an endless error loop
        --if in_error then return end
        --in_error = true

        --naughty.notify({ preset = naughty.config.presets.critical,
                         --title = "Oops, an error happened!",
                         --text = tostring(err) })
        --in_error = false
    --end)
--end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
--beautiful.init(awful.util.get_themes_dir() .. "byte/theme.lua")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/byte-pierre/theme.lua")

beautiful.column_count=3
--beautiful.master_count=3

--local apw = require("apw/widget")

-- This is used later as the default terminal and editor to run.
--terminal = "uxterm"
terminal = "WINIT_X11_SCALE_FACTOR=1 alacritty"
other_terminal = "gnome-terminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile.right,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", function () awful.spawn.with_shell(terminal) end}
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Graph Widgets
cpuwidget = wibox.widget.graph()
cpuwidget:set_width(60)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 60,0 }, stops = { {0, "#0191e5"}, {0.5, "#21B1e5" }, {1, "#000000"}}})
--cpuwidget.step_width = 2
cpuwidget.border_color = "#000000"
--cpuwidget:set_step_shape(function(cr, width, height)
  --gears.shape.rounded_rect(cr, width, height, 2)
--end)
--cpuwidget:set_stack(true)
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 1)
--vicious.register(cpuwidget, function () return math.random(100) end, "$1", 0.1)

memwidget = wibox.widget.graph()
memwidget:set_width(60)
memwidget:set_background_color("#494B4F")
memwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 60,0 }, stops = { {0, "#00b25a"}, {0.5, "#20b27a" }, {1, "#000000"}}})
memwidget.border_color = "#000000"
vicious.register(memwidget, vicious.widgets.mem, "$1", 1)
--vicious.register(memwidget, function () return math.random(100) end, "$1", 0.1)

netwidget = wibox.widget.graph()
netwidget:set_width(60)
netwidget:set_background_color("#494B4F")
netwidget.border_color = "#000000"
netwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 60,0 }, stops = { {0, "#edd400"}, {0.5, "#fce84d" }, {1, "#000000"}}})

netwidget:set_scale(false)
netwidget:set_min_value(0)
netwidget:set_max_value(1000) -- max MB/s of connection / 100 (because vicious divides down_kb by 100

vicious.register(netwidget, vicious.widgets.net, "${eth0 down_kb}", 1)

iowidget_sda = wibox.widget.graph()
iowidget_sda:set_width(60)
iowidget_sda:set_background_color("#494B4F")
iowidget_sda:set_color({ type = "linear", from = { 0, 0 }, to = { 60,0 }, stops = { {0, "#d88400"}, {0.5, "#e98f00" }, {1, "#000000"}}})
iowidget_sda.border_color = "#000000"
iowidget_sda:set_scale(false)
iowidget_sda:set_min_value(0)
--iowidget_sda:set_max_value(2) -- 200MB/s
--vicious.register(iowidget_sda, vicious.widgets.dio, "${sda total_mb}", 1)
iowidget_sda:set_max_value(10) -- 1000ms during 1s
vicious.register(iowidget_sda, vicious.widgets.dio, "${sdg iotime_ms}", 1)

--

local font = "DejaVu, 12"
local style = { font = font, bg_color = "red" }
--
-- Create a textclock widget
mytextclock = wibox.widget.textclock(nil, 5)
local cal = awful.widget.calendar_popup.month()
cal:attach(mytextclock, "tr")

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "⚡", "⛁", "☢", "⚓", 5, 6, 7, 8, "♫" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    mytextbox = wibox.widget.textbox()
    mytextbox:set_text("[" .. s.index .. "]")
    mytextbox:set_font(font)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, style)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, style)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            mytextbox,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            cpuwidget,
            memwidget,
            netwidget,
            iowidget_sda,
            mytextclock,
            s.mylayoutbox,
            --apw,
            volume_widget()
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    --awful.key({ }, "XF86AudioRaiseVolume",  apw.Up),
    --awful.key({ }, "XF86AudioLowerVolume",  apw.Down),
    --awful.key({ }, "XF86AudioMute",         apw.ToggleMute),
   
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    --awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              --{description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "twosuperior",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Pierre
    --awful.key({         }, "KP_Insert", function ()  end),
    --awful.key({         }, "U2044", function () awful.spawn("notify-send -t 1 NOPE") end),
    --awful.key({         }, "U2045", function () awful.spawn("notify-send 45") end),
    --awful.key({         }, "U2046", function () awful.spawn("notify-send 46") end),
    awful.key({         }, "Print", function () awful.spawn.with_shell("maim -s -c 1,0,0,0.8 -b 5 -p -5 | ~/dotfiles/clipboard/clip-gtk.py") end),
    awful.key({ "Shift" }, "Print", function () awful.spawn.with_shell("f=~/Pictures/Screenshots/\"screenshot-$(date +'%Y-%m-%d_%H:%M:%S').png\"; maim -s -c 1,0,0,0.8 -b 5 -p -5 \"$f\"; notify-send \"$f\"") end),
    awful.key({         }, "XF86MonBrightnessDown", function () awful.spawn("xbacklight -dec 5") end),
    awful.key({         }, "XF86MonBrightnessUp", function () awful.spawn("xbacklight -inc 5") end),
    awful.key({ modkey, }, "F11", function () awful.spawn(os.getenv("HOME") .. "/dotfiles/bin/toggle-touchpad") end),
    awful.key({ modkey,           }, "less", function () awful.spawn("dswitcher") end),
    awful.key({ modkey,           }, "a", function () awful.spawn("dmenu-launch") end),
    --awful.key({ modkey,           }, "Insert", function () awful.spawn(os.getenv("HOME") .. "/bin/ipowerstrip4.py") end),
    --awful.key({ modkey,           }, "Home", function () awful.spawn("xfce4-screenshooter -s /home/pierre/dev/sharedrop/drop --region") end),
    awful.key({ modkey, "Mod1"    }, "l", function () awful.spawn("xset s activate") end),
    awful.key({ modkey, "Mod1", "Shift" }, "l", function () awful.spawn("systemctl suspend") end),
    awful.key({ modkey,           }, "c", function () awful.spawn("playerctl play-pause") end),
    awful.key({ }, "XF86AudioPlay",       function () awful.spawn("playerctl play-pause") end),
    awful.key({ modkey,           }, "b", function () awful.spawn(os.getenv("HOME") .. "/dotfiles/bin/spotify-action.sh nexttrack") end),
    awful.key({ modkey,           }, "w", function () awful.spawn(os.getenv("HOME") .. "/dotfiles/bin/spotify-action.sh prevtrack") end),
    awful.key({ "Control" }, "F11", function () awful.spawn.with_shell("notify-send Hidden; sleep 0.1; killall -SIGUSR1 dunst"); end),
    awful.key({ "Control" }, "F12", function () awful.spawn("killall -SIGUSR2 dunst") end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn.with_shell(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "Return", function () awful.spawn.with_shell(other_terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    awful.key({ "Mod1" }, "Escape", function ()
      -- If you want to always position the menu on the same place set coordinates
      awful.menu.menu_keys.down = { "Down", "Alt_L" }
      awful.menu.clients(
        {theme = { width = 250 }},
        { keygrabber=true, coords={x=525, y=330} }
        )
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, ")", function (c) c.opacity = c.opacity - 0.05 end),
    awful.key({ modkey,           }, "=", function (c) c.opacity = c.opacity + 0.05 end),
    awful.key({ modkey,           }, "d", function (c) c.sticky = not c.sticky end),

    awful.key({ modkey,           }, "*",
        function (c)
            c.floating = false
            c.fullscreen = false
            c.ontop = false
            c.opacity = 1

            c.sticky = false
            c.urgent = false
            c.hidden = false
            c.minimized = false
            c.fullscreen = false
            c.maximized_horizontal = false
            c.maximized_vertical = false
            c.maximized = false

            c.above = false
            c.below = false
            c.modal = false
            c.ontop = false
            c.isbanned = false
            c.skip_taskbar = false
            c.nofocus = false
        end,
        {description = "reset", group = "client"}
        ),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"}),
    --awful.key({ modkey,           }, "Tab",
        --function ()
            --awful.client.focus.history.previous()
            --if client.focus then
                --client.focus:raise()
            --end
        --end,
        --{description = "go back", group = "client"}),
    -- Alt-Tab: cycle through clients on the same screen.
    -- This must be a clientkeys mapping to have source_c available in the callback.
    cyclefocus.key({ modkey, }, "Tab", {
        -- cycle_filters as a function callback:
        -- cycle_filters = { function (c, source_c) return c.screen == source_c.screen end },

        -- cycle_filters from the default filters:
        cycle_filters = { cyclefocus.filters.same_screen, cyclefocus.filters.common_tag },
        modifier='Super_L', keys = {'Tab', 'ISO_Left_Tab'}  -- default, could be left out
    })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry", "Pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true, titlebars_enabled = true }
    },
    { rule_any = {
      name = {
        "^Android Emulator*",
        "^Emulator",
      } },
      properties = {
        floating = true,
      }
    },
    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" } -- "normal", 
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
    { rule = { class = "Xfce4-notifyd" }, properties = { floating = true, border_width = 0 } },
    { rule = { class = "Key-mon" }, properties = { floating = true, border_width = 0, focusable = false } },

    { rule = { class = "Firefox", instance = "Navigator" }, properties = { floating = false, fullscreen = false, ontop = false } },
    { rule = { class = "Blender" }, properties = { floating = false, fullscreen = false, ontop = false } },
    --{ rule = { class = "Chromium" }, properties = { floating = false, fullscreen = false, ontop = false, maximized = false } },

    --{ rule = { class = "Firefox" }, properties = { tag = ttag(1, 3) } },

    --{ rule = { name = "ventrebl.eu" }, properties = { tag = ttag(1, 4) } },
    --{ rule = { name = "vpn.eshard.com" }, properties = { tag = ttag(1, 2) } },

    { rule = { class = "ioquake3.x86_64" }, properties = { fullscreen = false } },
    { rule = { class = "URxvt" }, properties = { size_hints_honor = false } },
    { rule = { class = "UXTerm" }, properties = { size_hints_honor = false } },
    { rule = { class = "st-256color" }, properties = { size_hints_honor = false } },
    { rule = { class = "Gnome-terminal" }, properties = { size_hints_honor = false } },
    { rule = { class = "Espwd.py" }, properties = { floating = true, ontop = true } },
    { rule = { class = "espwd.py" }, properties = { floating = true, ontop = true } },
    { rule = { name = "EGL test" }, properties = { floating = true, ontop = true } },
}

local floating = {
  "Pavucontrol",
  "Skype",
  "Keepass",
  "Keepassx",
  "keepassxc",
  "KeePassXC",
  "Mplayer",
  "pinentry",
  "gimp",
  "Thunderbird",
  "Google-chrome-unstable",
  "Vlc",
  "MPlayer",
  "Eclipse",
  "Evince",
  "Nautilus",
  "Steam",
  "qemu-system-arm",
  "Qemu-system-arm",
  "mpv",
  --"Firefox",
  "qemu-system-x86_64", "Qemu-system-x86_64",
  "Linphone",
  "Ekiga",
  "VirtualBox",
  "Wine", "arcanum.exe",
  "git-cola",
  "Godot",
  "Display",
  "Vncviewer",
}

for k, v in ipairs(floating) do
  awful.rules.rules[#awful.rules.rules + 1] = {rule={class=v}, properties={floating=true, titlebars_enabled=true}}
end
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }

    if not c.floating then
      awful.titlebar.hide(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("property::floating",
  function(c)
    if c.floating then
      awful.titlebar.show(c)
    else
      awful.titlebar.hide(c)
    end
  end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

