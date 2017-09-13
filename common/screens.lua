-- Generate the screen wibox and tag boxes
local awful     = require('awful'    )
local wibox     = require('wibox'    )
local beautiful = require('beautiful')

--- Screen Configuration
-- {{{ Screen config
awful.util.spawn(conf.tools.background_cmd .. " " .. conf.tools.background_cmdopts)

local spacer = conf.widgets.spacer or wibox.widget.textbox()
if conf.widgets.spacer == nil then
   spacer:set_text(" | ")
end

conf.tags = {}
for s = 1, screen.count() do
   conf.tags[s] = awful.tag(conf.screens[s].tags.names, s,
                            conf.screens[s].tags.layout)
end

for s = 1, screen.count() do
   --- Top Bar
   -- {{{
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

   --- Bottom Bar
   -- {{{
   conf.screens[s].bottom = awful.wibox({ position = "bottom", screen = s})
   
   conf.screens[s].bottom_layout = wibox.layout.align.horizontal()
   conf.screens[s].tasklist =
      awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags,
                            conf.buttons.tasklist)
   conf.screens[s].bottom_layout:set_middle(conf.screens[s].tasklist)
   conf.screens[s].bottom:set_widget(conf.screens[s].bottom_layout)
   -- }}}
end
-- }}}
