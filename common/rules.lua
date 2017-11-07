-------------------------------------------------------------------------------
-- rules.lua for Awesome Configuration                                      --
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
-- Client window rules
-- }}}

--- rules -- {{{
local awful     = require('awful')
local beautiful = require('beautiful')

local rules = {
   -- The global rule, applies to all client windows
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
   
   -- Floating clients
   { rule_any = { },
     class = {
        "MPlayer",
        "pinentry",
        "gimp",
     },
     name = {
        "Event Tester",
     },
     role = {
        "AlarmWindow",
        "pop-up",
     }, properties = { floating = true }},

   { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
   },

   -- { rule = { class = "emacs" },
   --   properties = { tag = conf.tags[1][2] } },
   -- { rule = { class = "firefox" },
   --   properties = { tag = conf.tags[1][4] } }
}

--- DEBUG -- {{{
if conf.debug then
   print("Custom rules loaded.")
end

-- }}}
awful.rules.rules = rules
return rules
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
-- awful.rules.rules = conf.rules
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
-- client.connect_signal("manage", function (c, startup)
--     -- Enable sloppy focus
--     c:connect_signal("mouse::enter", function(c)
--         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--             and awful.client.focus.filter(c) then
--             client.focus = c
--         end
--     end)

--     if not startup then
--         -- Set the windows at the slave,
--         -- i.e. put it at the end of others instead of setting it master.
--         -- awful.client.setslave(c)

--         -- Put windows in a smart way, only if they does not set an initial position.
--         if not c.size_hints.user_position and not c.size_hints.program_position then
--             awful.placement.no_overlap(c)
--             awful.placement.no_offscreen(c)
--         end
--     end

--     local titlebars_enabled = false
--     if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
--         -- buttons for the titlebar
--         local buttons = awful.util.table.join(
--                 awful.button({ }, 1, function()
--                     client.focus = c
--                     c:raise()
--                     awful.mouse.client.move(c)
--                 end),
--                 awful.button({ }, 3, function()
--                     client.focus = c
--                     c:raise()
--                     awful.mouse.client.resize(c)
--                 end)
--                 )

--         -- Widgets that are aligned to the left
--         local left_layout = wibox.layout.fixed.horizontal()
--         left_layout:add(awful.titlebar.widget.iconwidget(c))
--         left_layout:buttons(buttons)

--         -- Widgets that are aligned to the right
--         local right_layout = wibox.layout.fixed.horizontal()
--         right_layout:add(awful.titlebar.widget.floatingbutton(c))
--         right_layout:add(awful.titlebar.widget.maximizedbutton(c))
--         right_layout:add(awful.titlebar.widget.stickybutton(c))
--         right_layout:add(awful.titlebar.widget.ontopbutton(c))
--         right_layout:add(awful.titlebar.widget.closebutton(c))

--         -- The title goes in the middle
--         local middle_layout = wibox.layout.flex.horizontal()
--         local title = awful.titlebar.widget.titlewidget(c)
--         title:set_align("center")
--         middle_layout:add(title)
--         middle_layout:buttons(buttons)

--         -- Now bring it all together
--         local layout = wibox.layout.align.horizontal()
--         layout:set_left(left_layout)
--         layout:set_right(right_layout)
--         layout:set_middle(middle_layout)

--         awful.titlebar(c):set_widget(layout)
--     end
-- end)

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
