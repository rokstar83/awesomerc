--- menu.lua

-- Awesome System and client menus

local naughty      = require('naughty')
local awful        = require('awful')
awful.menu         = require('awful.menu')

-- do not use letters, which shadow access key to menu entry
awful.menu.menu_keys.down  = { "Down", ".", ">", "'", "\"", }
awful.menu.menu_keys.up    = {  "Up", ",", "<", ";", ":",   }
awful.menu.menu_keys.enter = { "Right", "]", "}", "=", "+", }
awful.menu.menu_keys.back  = { "Left", "[", "{", "-", "_",  }
awful.menu.menu_keys.exec  = { "Return", "Space",           }
awful.menu.menu_keys.close = { "Escape", "BackSpace",       }

-- Define the main menu

conf.mainmenu = awful.menu({
      theme = { width = 150, },
      items = conf.menus.main
})

