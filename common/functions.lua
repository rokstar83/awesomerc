-------------------------------------------------------------------------------
-- functions.lua for Functions for Awesome Configuration                     --
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
-- Helper functions for Awesome Configuration
-- }}}

--- Functions -- {{{
local awful = require('awful')
local funcs = {}

--- system_lock -- {{{
----------------------------------------------------------------------
-- lock the computer
----------------------------------------------------------------------
funcs.system_lock = function ()
   awful.util.spawn(conf.tools.screenlock_cmd .. ' ' ..
                       conf.tools.screenlock_cmdopts)
end
-- }}}

--- reboot -- {{{
----------------------------------------------------------------------
-- Prompt the user to confirm reboot and then do so
----------------------------------------------------------------------
funcs.reboot = function ()
   local scr = mouse.screen
   awful.prompt.run({prompt = "Reboot (type 'yes' to confirm)? "},
      conf.screens[src].promptbox,
      function (res)
         if string.lower(res) == 'yes' then
            awesome.emit_signal('exit',nil)
            awful.util.spawn('systemctl reboot')
         end
      end,
      function (t, p, n)
         return awful.completion.generic(t, p, n, {'no', 'NO', 'yes', 'YES'})
      end)
end
-- }}}

--- shutdown -- {{{
----------------------------------------------------------------------
-- Prompt the user to confirm shutdown and then do so
----------------------------------------------------------------------
funcs.shutdown = function ()
   local scr = mouse.screen
   awful.prompt.run({prompt = "Shutdown (type 'yes' to confirm)? "},
      conf.screens[src].promptbox,
      function (res)
         if string.lower(res) == 'yes' then
            awesome.emit_signal('exit',nil)
            awful.util.spawn('systemctl poweroff')
         end
      end,
      function (t, p, n)
         return awful.completion.generic(t, p, n, {'no', 'NO', 'yes', 'YES'})
   end)
end
-- }}}

--- cpu_temp -- {{{
----------------------------------------------------------------------
-- Return the CPU temperature
----------------------------------------------------------------------
funcs.cpu_temp = function (args)
   local thermal_path = args.thermal_path or "/sys/class/thermal/thermal_zone0/temp"
   local temp = 0
   
   if (awful.util.file_readable(thermal_path)) then
      temp = tonumber(awful.util.pread("cat " .. thermal_path))
   end
   
   -- temperatures are stored in thousands of a degree C
   return { temp / 1000 }
end

-- }}}

--- DEBUG -- {{{
if conf.debug then
   print("Custom functions loaded.")
end

-- }}}

return funcs
-- }}}
