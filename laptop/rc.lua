--- My laptop awesome config

--- Required files
-- {{{
local awful = require('awful')
local pass = dofile ('/home/thartman/projects/awesome-pass/awesome-pass.lua')
local beautiful = require('beautiful')
local vicious = require('vicious')
awful.client = require('awful.client')
awful.screen = require('awful.screen')
awful.rules = require ('awful.rules')
awful.menu = require('awful.menu')
wibox = require('wibox')
-- }}}

--- Initialize
-- {{{
-- The conf array contains and controls all elements for configuring
-- awesome. The goal is to have the awesome configuration more data
-- driven, hiding the actual implementation to modules and other libraries
conf = {}
conf.config_dir = '/home/' .. os.getenv('USER') .. '/.config/awesome/'
conf.modules_dir = conf.config_dir .. 'modules/'
conf.icon_dir = conf.config_dir .. 'icons/'
-- The modkey is the primary means of interacting with awesome. By
-- default this is set to mod4, sometimes called the 'super' key or
-- 'windows' key depending on your specific keyboard layout
modkey = 'Mod4'
-- }}}

--- Theme
-- {{{
 conf.theme = conf.modules_dir .. 'theme.lua'
 local beautiful = require('beautiful')
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

--- Common Functions
-- {{{
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

--- Widget definitions
-- {{{
-- Define the various widgets that will be
-- displayed in awesome.  These will be placed in wiboxes and system
-- trays in the 'Screen, Tags, and Layouts' section
conf.widgets = {}
conf.widgets.clock = awful.widget.textclock("%a %b %d, %l:%M")
conf.widgets.prompt = awful.widget.prompt()

--- pass widget
-- {{{
local base = wibox.widget.textbox()
base:set_text('')
local pass_args = {}
pass_args.prompt = conf.widgets.prompt
conf.widgets.pass = pass(base, pass_args )
-- }}}

-- temp widget
-- {{{
-- }}}

-- cpu widget
-- {{{
conf.widgets.cpu = wibox.layout.fixed.horizontal()
conf.widgets.cpu_graph = awful.widget.graph()
conf.widgets.cpu_graph:set_width(50)
conf.widgets.cpu_graph:set_background_color("#00000000")
conf.widgets.cpu_graph:set_color({ type = "linear", from = { 0, 0 }, to = { 50, 0 },
                                   stops = { { 0, "#001122" }, { 1, "#223355" } } })
conf.widgets.cpu_temp = wibox.widget.textbox()
vicious.register(conf.widgets.cpu_graph, vicious.widgets.cpu, "$1")
vicious.register(conf.widgets.cpu_temp, vicious.widgets.thermal, " $1 °С", 20, "thermal_zone0")

conf.widgets.cpu:add(conf.widgets.cpu_graph)
conf.widgets.cpu:add(conf.widgets.cpu_temp)
-- }}}

--- Volume widget
-- {{{
local audio = dofile('/home/thartman/projects/awesomerc/modules/audio.lua')
conf.widgets.vol_widget = wibox.layout.fixed.horizontal()
local up_vol = wibox.widget.textbox(" +")
local down_vol = wibox.widget.textbox("- ")
local vol_graph = awful.widget.progressbar()

up_vol:buttons(awful.util.table.join(
                  awful.button({}, 1,
                     function ()
                        audio:adjust_mixer_level("Master", 5)
                        vol_graph:refresh()                        
                     end)))
down_vol:buttons(awful.util.table.join(
                    awful.button({}, 1,
                       function ()
                          audio:adjust_mixer_level("Master", -5)
                          vol_graph:refresh()
                       end)))

vol_graph:set_width(50)
vol_graph:set_color("#FFFFFF")
vol_graph:set_background_color("#000000")
vol_graph.refresh = function ()
   local limits = audio:get_mixer_limits("Master")
   local levels = audio:get_mixer_level("Master")
   local current_val

   for k,v in pairs(levels) do
      current_val = v.level
      break
   end

   vol_graph:set_value(current_val / limits.upper)
end

vol_graph:refresh()
local vol_graph_layout = wibox.layout.margin()
vol_graph_layout:set_widget(vol_graph)
vol_graph_layout:set_top(5)
vol_graph_layout:set_bottom(5)

conf.widgets.vol_widget:add(down_vol)
conf.widgets.vol_widget:add(vol_graph_layout)
conf.widgets.vol_widget:add(up_vol)
-- }}}

-- battery monitor widget
-- {{{
--local bat = dofile ("/home/thartman/.config/awesome/modules/batmon.lua")
conf.widgets.batmon = wibox.widget.textbox()
-- conf.widgets.batmon = awful.widget.progressbar()
-- conf.widgets.batmon:set_height(8)
-- conf.widgets.batmon:set_width(10)
-- conf.widgets.batmon:set_vertical(true)
-- conf.widgets.batmon:set_background_color("#494B4F")
-- conf.widgets.batmon:set_border_color(nil)
-- conf.widgets.batmon:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 10 },
--                                stops = { { 0, "#AECF96" }, { 0.5, "#88A175" }, { 1, "#FF5656" }
-- }})

vicious.register(conf.widgets.batmon, vicious.widgets.bat, "$1$2 % ($3)", 5, "BAT0")
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
                            conf.widgets.batmon,
                            conf.widgets.vol_widget,
                            conf.widgets.cpu,
                            conf.widgets.pass,
                            conf.widgets.clock }

dofile (conf.modules_dir .. 'screens.lua')
-- }}}

--- Menus
-- tasklist widget
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
    { rule = { class = "Firefox" },
      properties = { tag = conf.tags[1][4] } }
}

-- Setup the windowing rules
dofile ('/home/thartman/projects/awesomerc/modules/rules.lua')

-- Setup client rules
dofile (conf.modules_dir .. 'client.lua')

-- }}}
