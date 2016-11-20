-------------------------------------------------------------------------------
-- audo.lua for  awesomerc                                                   --
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
local audio = { mt = {} }
local setmetatable = setmetatable
local util = require('awful.util')
-- }}}

-- Local Functions -- {{{

--- lines
-- @param str String to return as lines
-- Splits a string into a table of strings splitting by newlines
local function lines(str)
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
         local prop, val = line:match("([^:]+):([^:]+)")
         if prop ~= nil then retval[mixer_name][prop] = val or "" end
      end
   end

   return retval
end
-- }}}

--- audio:change_volume
-- @param mixer Name of the mixer to change (eg: Master, Headphone, etc)
-- @param step Amount to change
function audio:adjust_mixer_level (mixer, step) -- {{{
   
end
-- }}}

--- audio:get_mixer_level
-- @param mixer Name of the mixer level to get
function audio:get_mixer_level (mixer) -- {{{
   
end
-- }}}

--- audio:set_mixer_level
-- @param mixer Name of the mixer to change (eg: Master, Headphone, etc)
function audio:set_mixer_level (mixer, value) -- {{{
   
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

