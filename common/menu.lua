-------------------------------------------------------------------------------
-- menu.lua for Awesome Configuration                                        --
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
-- Define the menus for awesome
-- }}}

--- Menu -- {{{

local menu = {}

--- System Menu -- {{{
menus.sys = {
   { '&lock'     , conf.funcs.system_lock },
   { '&reboot'   , conf.funcs.reboot      },
   { '&shutdown' , conf.funcs.shutdown    },
}
-- }}}

--- Awesome Function Menu -- {{{
menus.awesome = {
   { '&edit config'     ,                 },
   { '&restart awesome' , awesome.restart },
   { '&quit awesome'    , awesome.quit    },
}
-- }}}

--- Application Menu -- {{{
menus.apps = {
}
-- }}}

--- Main Menu -- {{{
menus.main = {
   { '&system'  , conf.menus.sys     },
   { '&apps'    , conf.menus.apps    },
   { '&awesome' , conf.menus.awesome },
}

-- }}}

--- Awful Keyboard shortcuts -- {{{
local awful                = require('awful')
awful.menu                 = require('awful.menu')
awful.menu.menu_keys.down  = { "Down", ".", ">", "'", "\"", }
awful.menu.menu_keys.up    = {  "Up", ",", "<", ";", ":",   }
awful.menu.menu_keys.enter = { "Right", "]", "}", "=", "+", }
awful.menu.menu_keys.back  = { "Left", "[", "{", "-", "_",  }
awful.menu.menu_keys.exec  = { "Return", "Space",           }
awful.menu.menu_keys.close = { "Escape", "BackSpace",       }

-- }}}

return menu
-- }}}
