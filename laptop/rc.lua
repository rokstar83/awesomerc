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

--- Initialize
-- {{{
-- The conf array contains and controls all elements for configuring
-- awesome. The goal is to have the awesome configuration more data
-- driven, hiding the actual implementation to modules and other libraries
conf             = {}
conf.config_dir  = '/home/' .. os.getenv('USER') .. '/.config/awesome/'
conf.modules_dir = conf.config_dir .. 'modules/'
conf.icon_dir    = conf.config_dir .. 'icons/'

-- The modkey is the primary means of interacting with awesome. By
-- default this is set to mod4, sometimes called the 'super' key or
-- 'windows' key depending on your specific keyboard layout
modkey = 'Mod4'
-- }}}

--- Required files
-- {{{
local awful       = require('awful'    )
local radical     = require('radical'  )
local beautiful   = require('beautiful')
local vicious     = require('vicious'  )
local wibox       = require('wibox'    )
local modules     = require('modules'  )
-- }}}

--- Theme
-- {{{
conf.theme = conf.modules_dir .. 'theme.lua'
beautiful.init(conf.theme)
-- }}}

--- Default tools and programs
-- {{{
-- Defines programs and tools for common system functions
conf.tools = {}
conf.tools.terminal_cmd = 'urxvt'
conf.tools.compmgr_cmd = 'xcompmgr'
conf.tools.compmgr_cmdopts = '-f -c -s'
conf.tools.filemanager_cmd = 'mc'
conf.tools.browser_cmd = os.getenv('BROWSER') or 'firefox'
conf.tools.editor_cmd = os.getenv('EDITOR') or 'et'
conf.tools.screenlock_cmd = 'xscreensaver-command'
conf.tools.screenlock_cmdopts = '-l'
conf.tools.background_cmd = 'nitrogen'
conf.tools.background_cmdopts = '--restore'
-- }}}

--- Common Functions -- {{{
-- Defines common system functions for use in keybindings and menu
-- commands. Currently the defined functions are:
--    system_lock: Call the screen lock command as defined in the 'Tools
--                 and Programs' section
--    reboot: Queries the user if they really want to reboot and then calls
--            the reboot command as defined in the 'Tools and Programs' section
--    shutdown: Queries the user if they really want to shutdown the computer,
--              then calls the shutdown command as defined in the 'Tools and
--              Programs' section
--                  
conf.funcs = dofile (conf.modules_dir .. 'functions.lua')
-- }}}

--- Widget definitions -- {{{
-- Define the various widgets that will be
-- displayed in awesome.  These will be placed in wiboxes and system
-- trays in the 'Screen, Tags, and Layouts' section
conf.widgets = {}
conf.widgets.clock = wibox.widget.textclock()

local m, m_vals = awesome_cal:month_menu()
conf.widgets.clock:set_menu(m)
conf.widgets.prompt = awful.widget.prompt()

--- pass widget -- {{{
local base = wibox.widget.textbox()
base:set_text('')
local pass_args = {}
pass_args.prompt = conf.widgets.prompt
conf.widgets.pass = pass(base, pass_args )
-- }}}

-- temp widget
-- {{{
-- }}}

--- battery -- {{{
conf.widgets.batmon = dofile(conf.modules_dir .. 'batmon.lua')()
-- }}}

--- cpu monitor -- {{{
conf.widgets.cpu = dofile(conf.modules_dir .. "cpumon.lua")()
-- }}}

--- HDD monitor -- {{{
conf.widgets.hdd = require("awesome-disk")()

--- net widget testing -- {{{
local net = dofile(conf.modules_dir .. 'net.lua')
conf.widgets.wifi = net.wifi()

--conf.widgets.wifi = wibox.widget.textbox()
--vicious.register(conf.widgets.wifi, net.wifi, " $1 $2%", 5, "wlan0")
-- conf.widgets.wifi_button:buttons(awful.util.table.join(awful.button({}, 1,
--                                                           function ()
--                                                              local aps = net.wifi:available_ssids("wlan0")
                                                             
--                                                              for _,v in ipairs(aps) do
--                                                                 print(v)
--                                                              end
-- end)))

-- }}}

-- }}}

--- Mouse Buttons
-- {{{
dofile (conf.modules_dir .. 'mouse.lua')
-- }}}

--- Keybindings
-- {{{ 
conf.keys = {}
conf.keys.global = {
   { { modkey }, "F12", conf.funcs.system_lock },
   --   { { modkey }, "c"  , function () os.execute("xsel -p -i | xsel - i -b") end},
   { { modkey }, "Print",
      function () os.execute("scrot -e 'mv $f " .. conf.dirs.screenshots ..
                             " 2>/dev/null'" ) end},
}

conf.keys.client = {

}

dofile (conf.modules_dir .. 'keys.lua')
-- }}}

--- Screen, Layouts, and Tags
-- {{{
-- Define the number of screens, the number of tags per screen and the
-- layouts for the default layout for those tags. A 'screen' in this
-- case represents what will be present on the physical monitor. You
-- can define multiple screens here if you have multiple
-- monitors. Tags in awesome are what other window managers refer to
-- as workspaces or virtual desktops. The number or names of tags can
-- vary between screens. The 'layout' is how awesome will by default
-- organize the windows on that tag (tiling) 
conf.screens = {}
conf.layouts = {
   awful.layout.suit.floating,
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   awful.layout.suit.fair,
   awful.layout.suit.fair.horizontal,
   awful.layout.suit.spiral,
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.max,
   awful.layout.suit.max.fullscreen,
   awful.layout.suit.magnifier
}
conf.screens[1] = {}
conf.screens[1].tags =
   { names = {'chat','code','read','surf','watch','create','system','monitor',},
     layout = { conf.layouts[3],
                conf.layouts[10],
                conf.layouts[3],
                conf.layouts[10],
                conf.layouts[1],
                conf.layouts[1],
                conf.layouts[3],
                conf.layouts[4],
     }
   }
conf.screens[1].widgets = { conf.widgets.prompt,
                            conf.widgets.hdd,
                            conf.widgets.batmon,
                            conf.widgets.cpu,
                            conf.widgets.wifi,
                            conf.widgets.pass,                            
                            conf.widgets.clock }

dofile (conf.modules_dir .. 'screens.lua')
-- }}}

--- Menus-- tasklist widget
-- {{{ 
conf.menus = {}
conf.menus.sys = {
   { '&lock'     , conf.funcs.system_lock },
   { '&reboot'   , conf.funcs.reboot      },
   { '&shutdown' , conf.funcs.shutdown    },
}

conf.menus.awesome = {
   { '&edit config'     ,                 },
   { '&restart awesome' , awesome.restart },
   { '&quit awesome'    , awesome.quit    },
}

conf.menus.apps = {
}

conf.menus.main = {
   { '&system'  , conf.menus.sys     },
   { '&apps'    , conf.menus.apps    },
   { '&awesome' , conf.menus.awesome },
}

dofile (conf.modules_dir .. 'menu.lua')
-- }}}

--- Rules
-- {{{
-- Global rules to define how certain programs are
-- handled by awesome. Primarily this is used to let certain programs
-- 'float' rather than become part of the tiled window set. This is
-- useful for popup programs or programs that have their own method
-- for running in fullscreen mode

conf.rules = {
   { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = conf.clientkeys,
                     buttons = conf.buttons.client } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "emacs" },
      properties = { tag = conf.tags[1][2] } },
    { rule = { class = "firefox" },
      properties = { tag = conf.tags[1][4] } }
}

-- Setup the windowing rules
dofile ('/home/thartman/projects/awesomerc/modules/rules.lua')

-- Setup client rules
dofile (conf.modules_dir .. 'client.lua')

-- }}}


--- Testing
-- {{{
-- }}}
