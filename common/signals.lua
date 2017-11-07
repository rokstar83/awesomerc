-------------------------------------------------------------------------------
-- client.lua for Awesome configuration                                      --
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
-- Client rules and signals for Awesome
-- }}}

--- client -- {{{
-- this is lifted straight from the default awesome rc.lua file

local awful     = require('awful'    )
local beautiful = require('beautiful')
local wibox     = require('wibox'    )
local gears     = require('gears'    )

--- Signals -- {{{

--- mouse::enter -- {{{

-- This is basically sloppy focus
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
       and awful.client.focus.filter(c) then
          client.focus = c
    end
end)
-- }}}

--- manage -- {{{
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)    
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
-- }}}

--- request::titlebars -- {{{
client.connect_signal("request::titlebars", function(c)
   -- Buttons for the titlebar
   local buttons = gears.table.join(
      awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
   end))

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
         awful.titlebar.widget.floatingbutton(c),
         awful.titlebar.widget.maximizedbutton(c),
         awful.titlebar.widget.stickybutton(c),
         awful.titlebar.widget.ontopbutton(c),
         awful.titlebar.widget.closebutton(c),
         layout = wibox.layout.fixed.horizontal()
      },
      layout = wibox.layout.align.horizontal
   }   
end)

-- }}} 

--- focus -- {{{
client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
-- }}}

--- unfocus -- {{{
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- }}}

--- DEBUG -- {{{
if conf.debug then
   print("Custom signals loaded.")
end

-- }}}

return {}
-- }}}
