local awful = require('awful')

-- {{{ Mouse bindings

conf.buttons = {}

-- root buttons

conf.buttons.root = awful.util.table.join(
   awful.button({ }, 3, function () conf.mainmenu:toggle() end),
   awful.button({ }, 4, awful.tag.viewnext),
   awful.button({ }, 5, awful.tag.viewprev))

-- client buttons

conf.buttons.client = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- taglist
conf.buttons.taglist =
   awful.util.table.join(awful.button({ }, 1, awful.tag.viewonly),
                         awful.button({ modkey }, 1, awful.client.movetotag),
                         awful.button({ }, 2, awful.tag.viewtoggle),
                         awful.button({ modkey }, 2, awful.client.toggletag),
                         awful.button({ }, 3, function (t)
                               customization.func.tag_action_menu(t)
                         end),
                         awful.button({ modkey }, 3, awful.tag.delete),
                         awful.button({ }, 4, function(t)
                               awful.tag.viewprev(awful.tag.getscreen(t)) end),
                         awful.button({ }, 5, function(t)
                               awful.tag.viewnext(awful.tag.getscreen(t)) end))

-- tasklist
conf.buttons.tasklist =
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

--      awful.button({ }, 2, function (c)
--            customization.func.clients_on_tag()
--      end),

--      awful.button({ modkey }, 2, function (c)
--            customization.func.all_clients()
--      end),

--      awful.button({ }, 3, function (c)
--            customization.func.client_action_menu(c)
--      end),

      awful.button({ }, 4, function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
      end),

      awful.button({ }, 5, function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
   end))

root.buttons(conf.buttons.root)

-- }}}
