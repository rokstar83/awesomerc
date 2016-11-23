-------------------------------------------------------------------------------
-- net.lua for awesomerc                                                     --
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
-- Functions to get network information about the current system
--
-- }}}

--- Locals -- {{{
local util = require('awful.util')
local net = { mt = {} }
-- }}}

--- Local Functions -- {{{

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

--- trim
-- Return a string lacking white space at the beginning and end of the
-- string
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function map(func, arr)
   local retval = {}
   for i,v in ipairs(arr) do
      retval[i] = func(v)
   end
   return retval
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
-- }}}

--- Net Methods -- {{{

--- net.new

--- net:available_ifaces
-- Returns a list of available network interfaces
function net:available_ifaces () -- {{{
   local netstat_raw = lines(util.pread("netstat -i"))
   local ifaces = {}

   -- Remove the header from the iface list
   table.remove(netstat_raw, 1)
   table.remove(netstat_raw, 1)
   
   for _, v in ipairs(netstat_raw) do
      if v ~= "" or v ~= nil then
         ifaces[#ifaces+1] = trim(split(v, ' ', true)[1])
      end
   end
   
   return ifaces
end
-- }}}

--- net:bandwidth
function net:bandwidth (iface) -- {{{
   local iface = iface or self.iface
   local ifstat_raw = lines(util.pread("ifstat -i " .. iface .. " .1 1"))
   local bandwidth_parts = map(function (x) return tonumber(trim(x)) end,
      split(ifstat_raw[3], ' ', t))

--   print(#split(ifstat_raw[3], ' ', t))

   --   return { down = bandwidth_parts[1], up = bandwidth_parts[2] }
   return split(ifstat_raw[3], ' ', true)
end
-- }}}

function net.new (args) -- {{{
   local args = args or nil
   args.iface = args.iface or self:available_ifaces()[1]
end
-- }}}

--- net.__call
function net.__call (...) -- {{{
   return net.new(...)
end
-- }}}

return net
-- }}}

