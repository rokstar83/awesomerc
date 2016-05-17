-- Generate the screen wibox and tag boxes
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

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

-- {{{ Wibox
for s = 1, screen.count() do
   -- prompt box
   conf.screens[s].promptbox = awful.widget.prompt()

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

   -- tasklist widget
   conf.screens[s].tasklist =
      awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags,
                            conf.buttons.tasklist)

   -- Create the top wibox and put it all together
   conf.screens[s].top = awful.wibox({ position = "top", screen = s })

   -- Left top layout
   conf.screens[s].top_left_layout = wibox.layout.fixed.horizontal()
   conf.screens[s].top_left_layout:add(conf.screens[s].taglist)
   conf.screens[s].top_left_layout:add(conf.screens[s].promptbox)

   -- Right top layout
   conf.screens[s].top_right_layout = wibox.layout.fixed.horizontal()
   conf.screens[s].top_right_layout:add(conf.screens[s].layoutbox)
   for w = 1, table.getn(conf.screens[s].widgets) do
      conf.screens[s].top_right_layout:add(spacer)
      conf.screens[s].top_right_layout:add(conf.screens[s].widgets[w])      
   end

   -- Main layout
   conf.screens[s].top_layout = wibox.layout.align.horizontal()
   conf.screens[s].top_layout:set_left(conf.screens[s].top_left_layout)
   conf.screens[s].top_layout:set_middle(conf.screens[s].tasklist)
   conf.screens[s].top_layout:set_right(conf.screens[s].top_right_layout)

   -- and finally assign it to the top wibox
   conf.screens[s].top:set_widget(conf.screens[s].top_layout)
   
end
-- }}}
