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

--- Layouts -- {{{
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

--- tags -- {{{
screens.tags = {
   {'chat','code','read','surf','watch','create','system','monitor',}
}
-- }}}

--- set_wallpaper -- {{{
----------------------------------------------------------------------
-- Set the wallpaper for a specific screen based on the values in
-- beautiful.
--
-- This function is almost a straight lift from the default awesome
-- rc file
-- @param s the screen to set the wallpaper on
----------------------------------------------------------------------
function set_wallpaper (s)
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      if type(wallpaper) == "function" then
         wallpaper = wallpaper(s)
      end      
      gears.wallpaper.maximized(wallpaper, s, true)
   end
end
-- }}}

--- connect_screen -- {{{
----------------------------------------------------------------------
-- Function to call when a screen is created or setup
--
-- @param s Screen to setup
----------------------------------------------------------------------
screens.connect_screen = function (s)
   -- Wallpaper
   set_wallpaper(s)

   -- Tags
   awful.tag(screens.tags[s.index], s, screens.layouts)

   -- Prompt box
   s.prompt = awful.widget.prompt()

   -- Layout box
   s.layoutbox = awful.widget.layoutbox(s)
   s.layoutbox:buttons(conf.buttons.layoutbox)

   -- Tag List
   s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all,
                                    conf.buttons.taglist)

   -- Tasklist
   s.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags,
                                      conf.buttons.tasklist)

   -- Top Bar
   s.top_layout = awful.wibar({position = "top", screen = s})
   s.top_layout:setup {
      layout = wibox.layout.align.horizontal,
      -- left
      {
         layout = wibox.layout.fixed.horizontal,
         s.taglist,
         s.prompt
      },
      -- right
      {
         layout = wibox.layout.fixed.horizontal,
         -- wibox.widget.systray(),
         wibox.widget.textclock(),
         s.layout,
      },
   }

   -- Bottom Bar
   s.bottom_layout = awful.wibar({position = "bottom", screen = s})
   s.bottom_layout:setup {
      layout = wibox.layout.align.horizontal,
      s.tasklist,
   }      
end
-- }}}

--- DEBUG -- {{{
if conf.debug then
   print("Custom screens loaded.")
end

-- }}}

return screens
-- }}}
