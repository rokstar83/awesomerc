-------------------------------------------------------------------------------
-- cpumon.lua for awesomerc                                                  --
-- Copyright (c) 2016 Tom Hartman (thomas.lees.hartman@gmail.com)            --
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
-- Version 0.1:
-- When call cpumon will return a vicious registered widget with a cpu
-- usage linear graph and a cpu temperature read out
-- }}}

--- cpumon -- {{{

--- Locals -- {{{
local wibox = require('wibox')
local awful = require('awful')
local vicious = require('vicious')
local setmetatable = setmetatable

local cpumon = { mt = {} }
-- }}}

--- cpumon.new -- {{{
-- cpumon widget constructor
function cpumon.new (args)
   local w = wibox.layout.fixed.horizontal()
   local graph = awful.widget.graph()

   graph:set_width(50)
   graph:set_background_color("#00000000")
   graph:set_color( { type = "linear", from = {0, 0}, to = {50, 0},
                      stops = { { 0, "#001122" }, { 1, "#223355" } } })
   
   local temp = wibox.widget.textbox()
   vicious.register(graph, vicious.widgets.cpu, "$1")
   vicious.register(temp, vicious.widgets.thermal, " $1 °С", 20,
                    "thermal_zone0")

   --w.add(graph)
   --w.add(temp)

   return w
end
-- }}}

--- cpumon.mt:__call -- {{{
-- Functor function for cpumon
function cpumon.mt:__call (...)
   return cpumon.new(...)
end
-- }}}

return setmetatable(cpumon, cpumon.mt)
-- }}}
