--- keys.lua

-- Awesome key mappings

local awful = require ("awful")
local naughty = require ("naughty")

keys = awful.util.table.join(

   -- move to other screen
   awful.key({ modkey, }, "o",
      function (c)
         local curidx = awful.tag.getidx()
         if curidx == 1 and (client.focus ~= nil) then
            awful.client.movetotag(tags[client.focus.screen][2])
         elseif (client.focus ~= nil) then
            awful.client.movetotag(tags[client.focus.screen][1])
         end
   end),

   -- View previous tag
   awful.key({ modkey, }, ".", awful.tag.viewprev),

   -- Revert to last tag
   awful.key({ modkey, }, "Escape", awful.tag.history.restore),

   -- Focus!
   awful.key({ modkey, }, "j",
      function ()
         awful.client.focus.byidx( 1)
         if client.focus then client.focus:raise() end
   end),
   awful.key({ modkey, }, "k",
      function ()
         awful.client.focus.byidx(-1)
         if client.focus then client.focus:raise() end
   end),

   awful.key({ modkey, }, "Tab",
      function ()
         awful.client.focus.history.previous()
         if slient.focus then
            client.focus:raise()
         end
      end,
      "Switch to the next client"),

   -- Show the main menu
   awful.key({ modkey, }, "w", function () mainmenu:show() end),

   -- Volume commands
   -- TODO add volume code here
   -- awful.key({modkey, }, "PageUp", function () end)
   -- awful.key({modkey, }, "PageDown", function () end)
   -- awful.key({modkey, }, "Pause", function () end)

   -- Layout manipulations
   awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
      "Switch to the left"),
   awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
      "Switch to the right"),

   -- Spawning
   awful.key({modkey, }, "Return", function () awful.util.spawn(terminal) end,
      "Spawn Terminal"),
   awful.key({modkey, "Control"}, "r", awesome.restart,
      "Restart awesome"),
   awful.key({modkey, "Control"}, "q", awesome.quit,
      "Quit awesome"),

   -- change window sizes
   awful.key({ modkey, }, "l", function () awful.tag.incmwfact( 0.05) end,
      "increase the client size"),
   awful.key({ modkey, }, "h", function () awful.tag.incmwfact(-0.05) end,
      "decrease the client size"),
   awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster( 1) end),
   awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end),
   awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1) end),
   awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end),
   awful.key({ modkey, }, "p", function () conf.widgets.pass:toggle_pass_menu() end),

   -- lower and raise window
   awful.key({ modkey, "Control" }, "n",
      function ()
         awful.client.restore ()
         -- raise the restored client
         current_client = awful.client.next (-1)
         current_client:raise ()
      end,
      "raise and focus a minimized client"),

   awful.key({ modkey }, "x",
      function ()
         awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen].widget,
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
   end),

   -- Menubar
   awful.key({ modkey }, "r", function() menubar.show() end,
      "show the menu bar")  
) 

-- Finally put it all together and assign the keybindings to awesome
root.keys(keys)
