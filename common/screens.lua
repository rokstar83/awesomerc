-------------------------------------------------------------------------------
-- screens.lua for Awesome Configuration                                     --
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
-- Screen Configuration
-- }}}

-- Screen Config -- {{{

-- Generate the screen wibox and tag boxes
local awful     = require('awful'    )
local wibox     = require('wibox'    )
local beautiful = require('beautiful')

local screens   = {}

--- Screens -- {{{
screens.layouts = {
   awful.layout.suit.floating,
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   awful.layout.suit.fair,
   awful.layout.suit.fair.horizontal,
   awful.layout.suit.spiral,
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.max,
   awful.layout.suit.max.fullscreen,
   awful.layout.suit.magnifier
}
-- }}}

awful.util.spawn(conf.tools.background_cmd .. " " .. conf.tools.background_cmdopts)

conf.tags = {}
for s = 1, screen.count() do
   conf.tags[s] = awful.tag(conf.screens[s].tags.names, s,
                            conf.screens[s].tags.layout)
end

for s = 1, screen.count() do
   --- Top Bar -- {{{
   -- layout icon and key commands for the layout icon
   conf.screens[s].layoutbox = awful.widget.layoutbox(s)
   conf.screens[s].layoutbox:buttons(awful.util.table.join(
              awful.button({ }, 1, function ()
                    awful.layout.inc(conf.layouts,1) end),
              awful.button({ }, 2, function ()
                    awful.layout.inc(conf.layouts, -1) end),
              awful.button({ }, 3, function ()
                    awful.layout.inc(conf.layouts, -1) end),
              awful.button({ }, 4, function ()
                    awful.layout.inc(conf.layouts, 1) end),
              nil))

   -- taglist widget
   conf.screens[s].taglist =
      awful.widget.taglist(s, awful.widget.taglist.filter.all,
                           conf.buttons.taglist)

   -- Create the top wibox and put it all together
   conf.screens[s].top = awful.wibox({ position = "top", screen = s })

   -- Left top layout
   conf.screens[s].top_left_layout = wibox.layout.fixed.horizontal()
   conf.screens[s].top_left_layout:add(conf.screens[s].taglist)

   -- Right top layout
   conf.screens[s].top_right_layout = wibox.layout.fixed.horizontal()

   for w = 1, table.getn(conf.screens[s].widgets) do
      conf.screens[s].top_right_layout:add(conf.screens[s].widgets[w])
      conf.screens[s].top_right_layout:add(spacer)
   end

   conf.screens[s].top_right_layout:add(conf.screens[s].layoutbox)

   -- Main layout
   conf.screens[s].top_layout = wibox.layout.align.horizontal()
   conf.screens[s].top_layout:set_left(conf.screens[s].top_left_layout)
   conf.screens[s].top_layout:set_right(conf.screens[s].top_right_layout)

   -- and finally assign it to the top wibox
   conf.screens[s].top:set_widget(conf.screens[s].top_layout)
   -- }}}
   
   --- Bottom Bar -- {{{
   conf.screens[s].bottom = awful.wibox({ position = "bottom", screen = s})
   
   conf.screens[s].bottom_layout = wibox.layout.align.horizontal()
   conf.screens[s].tasklist =
      awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags,
                            conf.buttons.tasklist)
   conf.screens[s].bottom_layout:set_middle(conf.screens[s].tasklist)
   conf.screens[s].bottom:set_widget(conf.screens[s].bottom_layout)
   -- }}}
end

return screens
-- }}}
