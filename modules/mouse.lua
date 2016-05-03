local awful = require('awful')

-- {{{ Mouse bindings

-- Awesome buttons
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () conf.mainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

conf.clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- }}}
