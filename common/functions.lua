local awful = require('awful')
local funcs  = {}

-- Functions
-- {{{

funcs.system_lock = function ()
   awful.util.spawn(conf.tools.screenlock_cmd .. ' ' ..
                       conf.tools.screenlock_cmdopts)
end

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

funcs.reboot = function ()
   local scr = mouse.screen
   awful.prompt.run({prompt = "Reboot (type 'yes' to confirm)? "},
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

funcs.cpu_temp = function (args)
   local thermal_path = args.thermal_path or "/sys/class/thermal/thermal_zone0/temp"
   local temp = 0
   
   if (awful.util.file_readable(thermal_path)) then
      temp = tonumber(awful.util.pread("cat " .. thermal_path))
   end
   
   -- temperatures are stored in thousands of a degree C
   return { temp / 1000 }
end

return funcs

-- }}}
