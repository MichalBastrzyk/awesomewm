local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local M = "Mod4"
local C = "Control"
local A = "Mod1"
local S = "Shift"

local keys = { M = M, C = C, A = A }
local key = awful.key

function keys:define_global()
  local ks = gears.table.join(
    key({ M, }, "F1", hotkeys_popup.show_help,
      { description = "show help", group = "awesome" }),
    key({ M, }, "Left", awful.tag.viewprev,
      { description = "view previous", group = "tag" }),
    key({ M, }, "Right", awful.tag.viewnext,
      { description = "view next", group = "tag" }),
    key({ M, }, "Escape", awful.tag.history.restore,
      { description = "go back", group = "tag" }),
    key({ M, }, "j",
      function()
        awful.client.focus.byidx(1)
      end,
      { description = "focus next by index", group = "client" }
    ),
    key({ M, }, "k",
      function()
        awful.client.focus.byidx(-1)
      end,
      { description = "focus previous by index", group = "client" }
    ),
    key({ M, }, "w", function() mymainmenu:show() end,
      { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    key({ M, S }, "j", function() awful.client.swap.byidx(1) end,
      { description = "swap with next client by index", group = "client" }),
    key({ M, S }, "k", function() awful.client.swap.byidx(-1) end,
      { description = "swap with previous client by index", group = "client" }),
    key({ M, C }, "j", function() awful.screen.focus_relative(1) end,
      { description = "focus the next screen", group = "screen" }),
    key({ M, C }, "k", function() awful.screen.focus_relative(-1) end,
      { description = "focus the previous screen", group = "screen" }),
    key({ M, }, "u", awful.client.urgent.jumpto,
      { description = "jump to urgent client", group = "client" }),
    key({ M, }, "Tab",
      function()
        awful.client.focus.history.previous()
        if client.focus then
          client.focus:raise()
        end
      end,
      { description = "go back", group = "client" }),

    -- Standard program
    key({ M, }, "Return", function() awful.spawn(terminal) end,
      { description = "open a terminal", group = "launcher" }),
    key({ M, C }, "r", awesome.restart,
      { description = "reload awesome", group = "awesome" }),
    key({ M, S }, "q", awesome.quit,
      { description = "quit awesome", group = "awesome" }),

    key({ M, }, "l", function() awful.tag.incmwfact(0.05) end,
      { description = "increase master width factor", group = "layout" }),
    key({ M, }, "h", function() awful.tag.incmwfact(-0.05) end,
      { description = "decrease master width factor", group = "layout" }),
    key({ M, S }, "h", function() awful.tag.incnmaster(1, nil, true) end,
      { description = "increase the number of master clients", group = "layout" }),
    key({ M, S }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
      { description = "decrease the number of master clients", group = "layout" }),
    key({ M, C }, "h", function() awful.tag.incncol(1, nil, true) end,
      { description = "increase the number of columns", group = "layout" }),
    key({ M, C }, "l", function() awful.tag.incncol(-1, nil, true) end,
      { description = "decrease the number of columns", group = "layout" }),
    key({ M, }, "space", function() awful.layout.inc(1) end,
      { description = "select next", group = "layout" }),
    key({ M, S }, "space", function() awful.layout.inc(-1) end,
      { description = "select previous", group = "layout" }),

    key({ M, C }, "n",
      function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
          c:emit_signal(
            "request::activate", "key.unminimize", { raise = true }
          )
        end
      end,
      { description = "restore minimized", group = "client" }),

    -- Prompt
    key({ M }, "r", function() awful.screen.focused().mypromptbox:run() end,
      { description = "run prompt", group = "launcher" }),

    key({ M }, "x",
      function()
        awful.prompt.run {
          prompt       = "Run Lua code: ",
          textbox      = awful.screen.focused().mypromptbox.widget,
          exe_callback = awful.util.eval,
          history_path = awful.util.get_cache_dir() .. "/history_eval"
        }
      end,
      { description = "lua execute prompt", group = "awesome" })
  )

  for i = 1, 9 do
    ks = gears.table.join(ks,
      -- View tag only.
      key({ M }, "#" .. i + 9,
        function()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            tag:view_only()
          end
        end,
        { description = "view tag #" .. i, group = "tag" }),
      -- Toggle tag display.
      key({ M, "Control" }, "#" .. i + 9,
        function()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            awful.tag.viewtoggle(tag)
          end
        end,
        { description = "toggle tag #" .. i, group = "tag" }),
      -- Move client to tag.
      key({ M, "Shift" }, "#" .. i + 9,
        function()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:move_to_tag(tag)
            end
          end
        end,
        { description = "move focused client to tag #" .. i, group = "tag" }),
      -- Toggle tag on focused client.
      key({ M, "Control", "Shift" }, "#" .. i + 9,
        function()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:toggle_tag(tag)
            end
          end
        end,
        { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
  end

  return ks
end

function keys:define_client()
  return gears.table.join(
    key({ M, }, "f",
      function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
      end,
      { description = "toggle fullscreen", group = "client" }),
    key({ M, S }, "c", function(c) c:kill() end,
      { description = "close", group = "client" }),
    key({ M, C }, "space", awful.client.floating.toggle,
      { description = "toggle floating", group = "client" }),
    key({ M, C }, "Return", function(c) c:swap(awful.client.getmaster()) end,
      { description = "move to master", group = "client" }),
    key({ M, }, "o", function(c) c:move_to_screen() end,
      { description = "move to screen", group = "client" }),
    key({ M, }, "t", function(c) c.ontop = not c.ontop end,
      { description = "toggle keep on top", group = "client" }),
    key({ M, }, "n",
      function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
      end,
      { description = "minimize", group = "client" }),
    key({ M, }, "m",
      function(c)
        c.maximized = not c.maximized
        c:raise()
      end,
      { description = "(un)maximize", group = "client" }),
    key({ M, C }, "m",
      function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
      end,
      { description = "(un)maximize vertically", group = "client" }),
    key({ M, S }, "m",
      function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
      end,
      { description = "(un)maximize horizontally", group = "client" }),

    -- Media Controls for pipewire and playerctl

    key({}, "XF86AudioLowerVolume",
      function()
        os.execute("pactl -- set-sink-volume 0 -5%")
      end,
      { description = "Lower volume by 5%", group = "media" }),
    key({}, "XF86AudioRaiseVolume",
      function()
        os.execute("pactl -- set-sink-volume 0 +5%")
      end,
      { description = "Raise volume by 5%", group = "media" }),
    key({}, "XFreturn ksudioPrev",
      function()
        os.execute("playerctl previous")
      end,
      { description = "Play previous song", group = "media" }),
    key({}, "XF86AudioNext",
      function()
        os.execute("playerctl next")
      end,
      { description = "Play next song", group = "media" }),
    key({}, "XF86AudioPlay",
      function()
        os.execute("playerctl play-pause")
      end,
      { description = "Play/Pause", group = "client" })
  )
end

return keys
