-------------------------------------------------------------------------------
-- keys.lua for Awesome keyboard bindings                                  --
-- Copyright (c) 2017 Tom Hartman (thomas.lees.hartman@gmail.com)            --
--                                                                           --
-- This program is free software; you can redistribute it and/or             --
-- modify it under the terms of the GNU General Public License               --
-- as published by the Free Software Foundation; either version 2            --
-- of the License, or the License, or (at your option) any later             --
-- version.                                                                  --
--                                                                           --
-- This program is distributed in the hope that it will be useful,           --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of            --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             --
-- GNU General Public License for more details.                              --
-------------------------------------------------------------------------------

--- Commentary -- {{{
-- Keybindings for awesome
-- }}}

--- keys -- {{{
local awful   = require ("awful")
local keys    = {}
local modkey = conf.modkey

--- Global Keybindings -- {{{
keys.global = awful.util.table.join(

   --- Tag Key Bindings -- {{{
   awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
   awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
   awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

   awful.key({ modkey,           }, "l",
      function () awful.tag.incmwfact( 0.05)    end),
   awful.key({ modkey,           }, "h",
      function () awful.tag.incmwfact(-0.05)    end),
   awful.key({ modkey, "Shift"   }, "h",
      function () awful.tag.incnmaster( 1)      end),
   awful.key({ modkey, "Shift"   }, "l",
      function () awful.tag.incnmaster(-1)      end),
   awful.key({ modkey, "Control" }, "h",
      function () awful.tag.incncol( 1)         end),
   awful.key({ modkey, "Control" }, "l",
      function () awful.tag.incncol(-1)         end),
   -- }}}

   --- Client Window Key Bindings -- {{{
   awful.key({ modkey,           }, "j",
      function ()
         awful.client.focus.byidx( 1)
         if client.focus then client.focus:raise() end
   end),
   awful.key({ modkey,           }, "k",
      function ()
         awful.client.focus.byidx(-1)
         if client.focus then client.focus:raise() end
   end),
   awful.key({ modkey,           }, "w",
      function () mymainmenu:show() end),
   -- }}}
   
   --- Layout Key Bindings -- {{{
   awful.key({ modkey, "Shift"   }, "j",
      function () awful.client.swap.byidx(  1)    end),
   awful.key({ modkey, "Shift"   }, "k",
      function () awful.client.swap.byidx( -1)    end),
   awful.key({ modkey, "Control" }, "j",
      function () awful.screen.focus_relative( 1) end),
   awful.key({ modkey, "Control" }, "k",
      function () awful.screen.focus_relative(-1) end),
   awful.key({ modkey,           }, "u",
      awful.client.urgent.jumpto),
   awful.key({ modkey,           }, "Tab",
      function ()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
   end),
   awful.key({ modkey,           }, "space",
      function () awful.layout.inc(layouts,  1) end),
   awful.key({ modkey, "Shift"   }, "space",
      function () awful.layout.inc(layouts, -1) end),
   awful.key({ modkey, "Control" }, "n",
      awful.client.restore),
   -- }}}
   
   -- Program Key Bindings -- {{{
   awful.key({ modkey,           }, "Return",
      function ()
         awful.util.spawn(conf.tools.terminal_cmd)
   end),
   -- }}}

   -- Awesome Key Bindings -- {{{
   awful.key({ modkey, "Control" }, "r", awesome.restart),
   awful.key({ modkey, "Shift"   }, "q", awesome.quit),
   -- }}}      
         
   -- Prompt Key Bindings -- {{{
   awful.key({ modkey },            "r",
      function ()
         awful.screen.focused().prompt:run() end),
   
   awful.key({ modkey }, "x",
      function ()
         awful.prompt.run({ prompt = "Run Lua code: " },
            conf.widgets.prompt.widget,
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
   end)
   -- }}}
)

for i = 1, 9 do
   keys.global = awful.util.table.join(
      keys.global,
      -- View Tag
      awful.key({ conf.modkey }, "#" .. i + 9,
         function ()
            local screen = mouse.screen
            local tag    = awful.tag.gettags(screen)[i]
            if tag then awful.tag.viewonly(tag) end
      end),
      -- Toggle Tag
      awful.key({ conf.modkey, "Control" }, "#" .. i + 9,
         function ()
            local screen = mouse.screen
            local tag    = awful.tag.gettags(screen)[i]
            if tag then awful.tag.viewonly(tag) end
      end),
      -- Move Client to Tag.
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
         function ()
            if client.focus then
               local tag = awful.tag.gettags(client.focus.screen)[i]
               if tag then awful.client.movetotag(tag) end
            end
      end),
      -- Toggle Tag
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
         function ()
            if client.focus then
               local tag = awful.tag.gettags(client.focus.screen)[i]
               if tag then awful.client.toggletag(tag) end
            end
      end)
   )
end
         
-- }}}

--- Client Key Bindings -- {{{
keys.client = awful.util.table.join(
   awful.key({ modkey,           }, "f",
      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ modkey, "Shift"   }, "c",
      function (c) c:kill()                         end),
   awful.key({ modkey, "Control" }, "space",
      awful.client.floating.toggle                     ),
   awful.key({ modkey, "Control" }, "Return",
      function (c) c:swap(awful.client.getmaster()) end),
   awful.key({ modkey,           }, "o",
      awful.client.movetoscreen                        ),
   awful.key({ modkey,           }, "t",
      function (c) c.ontop = not c.ontop            end),
   awful.key({ modkey,           }, "n",
      function (c)
         -- The client currently has the input focus, so it cannot be
         -- minimized, since minimized clients can't have the focus.
         c.minimized = true
   end),
   awful.key({ modkey,           }, "m",
      function (c)
         c.maximized_horizontal = not c.maximized_horizontal
         c.maximized_vertical   = not c.maximized_vertical
   end)
    
)
-- }}}

return keys
-- }}}
