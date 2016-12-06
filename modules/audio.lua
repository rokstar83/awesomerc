-------------------------------------------------------------------------------
-- audio.lua for  awesomerc                                                  --
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
-- Simple volume/audio widget for awesome wm
-- }}}

--- Locals -- {{{
local util = require('awful.util')
local audio = { mt = {} }
local setmetatable = setmetatable
local tonumber = tonumber

-- }}}

-- Local Functions -- {{{

--- lines
-- @param str String to return as lines
-- Splits a string into a table of strings splitting by newlines
local function lines(str) -- {{{
   local t = {}
   local function helper(line) table.insert(t, line) return "" end
   helper((str:gsub("(.-)\r?\n", helper)))
   return t
end
-- }}}

--- get_amixer_raw
-- Return the raw output of amixer
local function get_amixer_raw () -- {{{
   return util.pread("amixer")
end
-- }}}

--- trim
-- Return a string lacking white space at the beginning and end of the
-- string
function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function map(func, arr)
   local retval = {}
   for i,v in ipairs(arr) do
      retval[i] = func(v)
   end
   return retval
end

--- split
local function split(str, delim, noblanks)
   local t = {}
   if str == nil then
      return t
   end
   
   local function helper(part)
      table.insert(t, part)
      return ""
   end
   helper((str:gsub("(.-)" .. delim, helper)))

   if noblanks then
      return remove_blanks(t)
   else
      return t
   end
end

--- remove_blanks
local function remove_blanks(t)
   local retval = {}
   for _, s in ipairs(t) do
      if s ~= "" and s ~= nil then
         table.insert(retval, s)
      end
   end
   return retval
end

-- }}}

--- Member Functions -- {{{

--- audio:get_mixers
-- Return a table of the existing mixers
function audio:get_mixers () -- {{{
   local amixer_raw = get_amixer_raw()
   local retval = {}
   local mixer_name = ""
   
   for _,line in ipairs(lines(amixer_raw)) do
      if string.sub(line, 1, 1) ~= ' ' then
         mixer_name = line:match("'(.*)'")
         if mixer_name ~= nil then retval[mixer_name] = {} end
      else
         local parts = split(line, ":", t, t)
         if #parts > 1 then            
            retval[mixer_name][trim(parts[1])] = trim(parts[2])
         end
      end
   end

   return retval
end
-- }}}

--- audio:change_volume
-- @param mixer Name of the mixer to change (eg: Master, Headphone, etc)
-- @param step Amount to change
function audio:adjust_mixer_level (mixer, step) -- {{{
   local levels = self:get_mixer_level(mixer)
   local chan
   
   for k, v in pairs(levels) do
      chan = v
      break
   end

   self:set_mixer_level(mixer, chan.level+step)
end
-- }}}

--- audio:get_mixer_level
-- @param mixer Name of the mixer level to get
--
-- Returns a table of the available channels for the mixer with the
-- current volume level of the channel
function audio:get_mixer_level (mixer) -- {{{
   local mixers = audio:get_mixers()

   if mixers[mixer] == nil then
      return {}
   end

   local channel_names = map(trim,split(mixers[mixer]["Playback channels"],"-",t))
   local levels = {}
   for _,channel_name in ipairs(channel_names) do
      levels[channel_name] = {}
      local parts = split(mixers[mixer][channel_name], " ", t)
      local channel_type, level, level_pct, db, state = "","","","",""

      if #parts == 5 then
         channel_type, level, level_pct, db, state = parts[1], parts[2], parts[3], parts[4], parts[5]
      elseif #parts == 4 then
         channel_type, level, level_pct, db = parts[1], parts[2], parts[3], parts[4]
      else
         level, level_pct, db = parts[1], parts[2], parts[3]
      end

      levels[channel_name]["channel"] = channel_type or ""
      levels[channel_name]["level"] = tonumber(level)
      levels[channel_name]["level_pct"] = tonumber(level_pct:match("%[(%d+)%%%]"))
      levels[channel_name]["db"] = db
      levels[channel_name]["state"] = state or ""
   end
   
   return levels
end
-- }}}

--- audio:get_mixer_limits
-- 
function audio:get_mixer_limits (mixer) -- {{{
   local mixers = audio:get_mixers(mixer)

   if mixers[mixer] == nil then
      return {}
   end

   local lower, upper = mixers[mixer]["Limits"]:match("(%d+) %- (%d+)")

   return { lower = tonumber(lower),
            upper = tonumber(upper) }
end
-- }}}

--- audio:set_mixer_level
-- @param mixer Name of the mixer to change (eg: Master, Headphone, etc)
function audio:set_mixer_level (mixer, value) -- {{{
   -- Check that the value is sane
   local limits = self:get_mixer_limits(mixer)
   
   if value < limits.lower or value > limits.upper then
      return
   end

   
   local _ = util.pread("amixer sset " .. mixer .. " " .. value)
end
-- }}}

--- audio:toggle_mixer_menu
-- 
function audio:toggle_mixer_menu () -- {{{
   
end
-- }}}

--- audio.new
-- @param args Arguments passed to the constructor
function audio.new (args) -- {{{
   local args = args or {}
   local retval = {}
   
   retval.amixer_cmd = "amixer"

   return retval
end
-- }}}

--- audio.mt:__call
-- 
function audio.mt:__call (...) -- {{{
   return audio.new(...)
end
-- }}}

-- }}}

return audio

--- Volume widget
-- {{{
-- local audio = dofile('/home/thartman/projects/awesomerc/modules/audio.lua')
-- conf.widgets.vol_widget = wibox.layout.fixed.horizontal()
-- local up_vol = wibox.widget.textbox(" +")
-- local down_vol = wibox.widget.textbox("- ")
-- local vol_graph = awful.widget.progressbar()

-- up_vol:buttons(awful.util.table.join(
--                   awful.button({}, 1,
--                      function ()
--                         audio:adjust_mixer_level("Master", 5)
--                         vol_graph:refresh()                        
--                      end)))
-- down_vol:buttons(awful.util.table.join(
--                     awful.button({}, 1,
--                        function ()
--                           audio:adjust_mixer_level("Master", -5)
--                           vol_graph:refresh()
--                        end)))

-- vol_graph:set_width(50)
-- vol_graph:set_color("#FFFFFF")
-- vol_graph:set_background_color("#000000")
-- vol_graph.refresh = function ()
--    local limits = audio:get_mixer_limits("Master")
--    local levels = audio:get_mixer_level("Master")
--    local current_val

--    for k,v in pairs(levels) do
--       current_val = v.level
--       break
--    end

--    vol_graph:set_value(current_val / limits.upper)
-- end

-- vol_graph:refresh()
-- local vol_graph_layout = wibox.layout.margin()
-- vol_graph_layout:set_widget(vol_graph)
-- vol_graph_layout:set_top(5)
-- vol_graph_layout:set_bottom(5)

-- conf.widgets.vol_widget:add(down_vol)
-- conf.widgets.vol_widget:add(vol_graph_layout)
-- conf.widgets.vol_widget:add(up_vol)
-- }}}
