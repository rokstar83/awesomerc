--- battery monitor widget -- {{{
local vicious = require("vicious")
local wibox = require("wibox")

local batmon = { mt = {} }

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

return batmon
-- }}}
