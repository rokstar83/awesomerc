-------------------------------------------------------------------------------
-- rc.lua for Awesome Configuration                                          --
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
-- 
-- }}}

--- Awesome Configuration -- {{{

--- Initialize -- {{{

-- The conf array contains and controls all elements for configuring
-- awesome. The goal is to have the awesome configuration more data
-- driven, hiding the actual implementation to modules and other libraries

conf            = {}
conf.config_dir = '/home/' .. os.getenv('USER') .. '/.config/awesome/'
conf.icon_dir   = conf.config_dir .. 'icons/'

-- Setup the package path so that all needed configuration libraries can be
-- included
package.path = conf.config_dir .. "common/?.lua;" .. conf.config_dir ..
   "widgets/?.lua;" .. package.path

conf.modkey = 'Mod4'
-- }}}

-- Error Handling -- {{{

local naughty = require('naughty')

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

--- Theme -- {{{
local beautiful = require('beautiful')
conf.theme = conf.config_dir .. 'theme.lua'
beautiful.init(conf.theme)
-- }}}

conf.keys    = require('keys'      )
conf.buttons = require('buttons'   )
conf.widgets = require('widgets'   )
conf.tools   = require('tools'     )
conf.screens = require('screens'   )
conf.client  = require('client'    )
conf.rules   = require('rules'     )
conf.funcs   = require('functions' )
conf.menu    = require('menu'      )

--- Finalize -- {{{
root.keys(conf.keys.global)
root.buttons(conf.buttons.global)

local awful = require('awful'      )

awful.screen.connect_for_each_screen(conf.screens.connect_screen)
-- }}}

-- }}}
