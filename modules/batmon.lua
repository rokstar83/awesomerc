-------------------------------------------------------------------------------
-- batmon.lua for awesomerc                                                  --
-- Copyright (c) 2016 Tom Hartman (thartman@hudco.com)                       --
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
-- 
-- }}}

--- batmon -- {{{

--- Locals -- {{{
local vicious = require("vicious")
local wibox = require("wibox")
local setmetatable = setmetatable

local batmon = { mt = {} }
-- }}}

--- batmon.new() -- {{{
--
function batmon.new ()
   local w = wibox.widget.textbox()
   vicious.register(w, vicious.widgets.bat, "$1$2 % ($3)", 5, "BAT0")
   return w
end
-- }}}
 
--- batmon.mt:__call -- {{{
--
function batmon.mt:__call(...)
   return batmon.new(...)
end
-- }}}

return setmetatable(batmon, batmon.mt)
-- }}}
