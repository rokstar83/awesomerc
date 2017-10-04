-------------------------------------------------------------------------------
-- buttons.lua for Awesome Configuration                                     --
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
-- Mouse configuration options, called buttons because mouse is already a
-- lua library in awesome
-- }}}

--- mouse -- {{{
local awful   = require('awful')
local gears   = require('gears')
local buttons = {}

--- global mouse buttons -- {{{
-- Mouse actions captured by awesome (uncaptured by client windows)
--- Right Click: show awesome menu
--- Scroll Up: Move to the previous tag
--- Scroll Down: Move to the next tag
buttons.global = gears.table.join(
   awful.button({ }, 3, function () conf.menu.main:toggle() end),
   awful.button({ }, 4, awful.tag.viewnext),
   awful.button({ }, 5, awful.tag.viewprev))
-- }}}

--- client mouse buttons -- {{{
-- Mouse actions captured by the client window
--- Left Click: Raise the client window
--- Mod+Left Click: Move the client window
--- Mod+Right Client: Resize client window
buttons.client = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ conf.modkey }, 1, awful.mouse.client.move),
    awful.button({ conf.modkey }, 3, awful.mouse.client.resize))

-- }}}

--- titlebar mouse buttons -- {{{
-- Mouse actions captured by a titlebar
--- Left Click:  Move client window associated with the titlebar
--- Right Click: Resize client window associated with the titlebar
buttons.titlebar = gears.table.join(
   awful.button({}, 1, function (c)
         client.focus = c
         c:raise()
         awful.mouse.client.move(c)
   end),
   awful.button({}, 3, function (c)
         client.focus = c
         c:raise()
         awful.mouse.client.resize(c)
   end)
)
-- }}}

--- taglist mouse mouse -- {{{
-- Mouse actions captured by the tag list
--- Left Click:       Show windows associate only associated with the tag
--- Mod+Left Click:   Move currently selected client window to tag
--- Middle Click:     Toggle show/hide for windows associated with the tag
--- Mod+Middle Click: Toggle tagging the selected client window with the tag
--- Right Click:      NA
--- Mod+Right Click:  Delete Tag
--- Scroll Up:        Move to the previous tag
--- Scroll Down:      Move to the next tag
buttons.taglist = gears.table.join(
   awful.button({ }, 1, awful.tag.viewonly),
   awful.button({ conf.modkey }, 1, awful.client.movetotag),
   awful.button({ }, 2, awful.tag.viewtoggle),
   awful.button({ conf.modkey }, 2, awful.client.toggletag),

   awful.button({ conf.modkey }, 3, awful.tag.delete),
   awful.button({ }, 4, function(t)
         awful.tag.viewprev(awful.tag.getscreen(t)) end),
   awful.button({ }, 5, function(t)
         awful.tag.viewnext(awful.tag.getscreen(t)) end))
-- }}}

--- tasklist mouse buttons -- {{{
-- Mouse actions captured by the task list
--- Left Click:  Change focus to the selected client window
--- Scroll Up:   Change focus to the previous client window
--- Scroll Down: Change focus to the next client window
buttons.tasklist =
   awful.util.table.join(      
      awful.button({ }, 1, function (c)
            if c == client.focus then
               c.minimized = true
            else
               -- Without this, the following
               -- :isvisible() makes no sense
               c.minimized = false
               if not c:isvisible() then
                  awful.tag.viewonly(c:tags()[1])
               end
               -- This will also un-minimize
               -- the client, if needed
               client.focus = c
               c:raise()
            end
      end),
      awful.button({ }, 4, function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
      end),
      awful.button({ }, 5, function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
   end))
-- }}}

--- layoutbox mouse buttons -- {{{
-- Mouse actions captured by the layoutbox on each screen
-- Left Click:  Switch current tag to next layout
-- Right Click: Switch current tag to previous layout
-- Scroll Up:   Switch current tag to next layout
-- Scroll Down: Switch current tag to previous layout
buttons.layoutbox = gears.table.join(awful.button({ }, 1, function () awful.layout.inc( 1) end),
                                   awful.button({ }, 3, function () awful.layout.inc(-1) end),
                                   awful.button({ }, 4, function () awful.layout.inc( 1) end),
                                   awful.button({ }, 5, function () awful.layout.inc(-1) end)) 
-- }}}

return buttons
-- }}}
