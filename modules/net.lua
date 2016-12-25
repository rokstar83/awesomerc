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
local awful = require('awful')
local util = require('awful.util')
local wibox = require('wibox')
local vicious = require('vicious')
local net = { mt = {} }
local wifi = { mt = {} }
net.wifi = wifi
local setmetatable = setmetatable
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
   if s ~= nil then
      return (s:gsub("^%s*(.-)%s*$", "%1"))
   else
      return nil
   end
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

-- table_update
local table_update = function (t, set)
    for k, v in pairs(set) do
        t[k] = v
    end
    return t
end

--- build_connect_func -- {{{
-- @param ssid name of the network to connect to
function build_connect_func (wlan_iface, ssid)
   return function ()
      local cmd = "gksudo \"sh -c '/usr/sbin/iw " .. wlan_iface .. " disconnect; " ..
         "/usr/sbin/iw " .. wlan_iface .. " connect \\\"" .. ssid .. "\\\"'\""
      print(cmd)
      awful.util.spawn(cmd)
   end
end
-- }}}

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

-- }}}

--- Wifi Methods -- {{{

--- wifi:available_ssids
-- @param wlan_iface name of the wireless network interface
function wifi:available_ssids (wlan_iface) -- {{{
   local wlan_iface = wlan_iface or self.wlan_iface
   local ssid_raw = lines(util.pread("gksudo iw " .. wlan_iface .. " scan | grep SSID"))
   local ssids = {}

   for _, v in ipairs(ssid_raw) do
      local parts = split(v, ":", true)
      table.insert(ssids, trim(parts[2]))
   end

   return remove_blanks(ssids)
end
-- }}}

--- wifi:current_ssid
-- @param wlan_iface name of the wireless network interface
function wifi:current_ssid (wlan_iface) -- {{{
   local wlan_iface = wlan_iface or self.wlan_iface
   local raw = lines(util.pread("/usr/sbin/iw " .. wlan_iface .. " link | grep SSID"))
   
   local parts = split(raw[1], ":", true)
   
   if #parts == 2 then
      return trim(parts[2])
   else
      return nil
   end
end
-- }}}

--- wifi:signal_strength
-- @param wlan_iface name of the wireless network interface
function wifi:signal_strength (wlan_iface) -- {{{
   local wlan_iface = wlan_iface or self.wlan_iface
   local raw = util.pread("/usr/sbin/iw " .. wlan_iface .. " link | grep signal")

   local dbm = tonumber(string.match(raw, "(-[%d]*) dBm"))

   local quality = 2 * (dbm + 100)
   if quality > 100 then
      return 100
   elseif quality < 0 then
      return 0
   else
      return quality
   end     
end
-- }}}

--- wifi:connect -- {{{
-- @param ssid name of the wifi network to connect to
function wifi:connect (ssid, wlan_iface)
   local wlan_iface = wlan_iface or self.wlan_iface

   -- util.pread("/usr/sbin/iw " .. wlan_iface .. " connect"
end
-- }}}

--- wifi:connect_menu -- {{{
-- 
function wifi:gen_connect_menu (wlan_iface)
   local wlan_iface = wlan_iface or self.wlan_iface
   local ssid_tbl = wifi:available_ssids(wlan_iface)

   local retval = {}
   for _, s in ipairs(ssid_tbl) do
      table.insert(retval, { s, build_connect_func(wlan_iface, s)})
   end

   return awful.menu(retval)
end
-- }}}

--- wifi:show_connect_menu -- {{{
-- 
function wifi:show_connect_menu (wlan_iface)
   local wlan_iface = wlan_iface or self.wlan_iface

   self.connect_menu = wifi:gen_connect_menu(wlan_iface)
   self.connect_menu:toggle()
end
-- }}}

--- wifi.worker
-- 
function wifi.worker (format, wlan_iface) -- {{{
   local ssid = wifi:current_ssid(wlan_iface)
   local strength = 0

   if ssid ~= nil then
      strength = wifi:signal_strength(wlan_iface)
   end
   
   return { ssid or "No AP Found", strength }
end
-- }}}

--- wifi.new -- {{{
-- 
function wifi.new (format, refresh_rate, wlan_iface)
   local w = table_update(wibox.widget.textbox(), wifi)

   w.format = format or " $1 $2%"
   w.refresh_rate = refresh_rate or 5
   w.wlan_iface = wlan_iface or "wlan0"

   w:buttons(awful.util.table.join(
                awful.button({}, 1,
                   function ()
                      w:show_connect_menu()
   end)))
   
   vicious.register(w, net.wifi.worker, w.format, w.refresh_rate,
                    w.wlan_iface)

   return w
end
-- }}}

-- }}}

setmetatable(wifi, {__call = function(_,...) return wifi.new(...) end})

return net
