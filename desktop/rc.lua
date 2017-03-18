--- Desktop awesome config
--- Copyright 2016 Tom Hartman (thomas.lees.hartman@gmail.com)

--- Required files
-- {{{
local awful = require('awful')
local pass = require('awesome-pass')
local wibox = require('wibox')
local vicious = require('vicious')
awful.client = require('awful.client')
awful.screen = require('awful.screen')
awful.rules = require ('awful.rules')
awful.menu = require('awful.menu')
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
conf.dirs = {}
conf.dirs.screenshots = "~/pictures/screenshots/"
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
conf.widgets.clock = awful.widget.textclock()
conf.widgets.prompt = awful.widget.prompt()

--- pass widget
-- {{{
local base = wibox.widget.textbox()
base:set_text('')
local pass_args = {}
pass_args.prompt = conf.widgets.prompt
conf.widgets.pass = pass(base, pass_args )
-- }}}

-- cpu widget
-- {{{
conf.widgets.cpu = wibox.layout.fixed.horizontal()
conf.widgets.cpu_icon = wibox.widget.textbox()
conf.widgets.cpu_icon:set_text(' ')
conf.widgets.cpu_graph = awful.widget.graph()
conf.widgets.cpu_graph:set_width(50)
conf.widgets.cpu_graph:set_background_color("#00000000")
conf.widgets.cpu_graph:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 },
                                   stops = { {0, "#113456"}, {0.5, "#113477"},
                                      {1, "#1134BB" }}})
conf.widgets.cpu_temp = wibox.widget.textbox()
conf.widgets.cpu:add(conf.widgets.cpu_icon)
conf.widgets.cpu:add(conf.widgets.cpu_graph)
-- Register widget
vicious.register(conf.widgets.cpu_graph, vicious.widgets.cpu, "$1")
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
      function () awful.util.spawn("scrot -d 5 -e 'mv $f " ..
                                   conf.dirs.screenshots .. "'") end},
   { { modkey }, "p", function () conf.widgets.pass:toggle_pass_show() end}
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

-- Right screen definition
conf.screens[1] = {}
conf.screens[1].tags =
   { names = {'surf','connect','create','play','watch','listen','monitor'},
     layout = {awful.layout.suit.max,
               awful.layout.suit.max,
               awful.layout.suit.floating,
               awful.layout.suit.max,
               awful.layout.suit.max,
               awful.layout.suit.max,
               awful.layout.suit.tile.left}
   }

conf.screens[1].widgets = { conf.widgets.prompt,
                            conf.widgets.cpu,
                            conf.widgets.pass,
                            conf.widgets.clock,}

-- Left screen definition
conf.screens[2] = {}
conf.screens[2].tags =
   { names = {'chat', 'code', 'read', 'system'},
     layout = {awful.layout.suit.tile.left,
               awful.layout.suit.max,
               awful.layout.suit.tile.bottom,
               awful.layout.suit.tile.left}
   }
conf.screens[2].widgets = {}

dofile (conf.modules_dir .. 'screens.lua')
-- }}}

--- Menus
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
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = conf.clientkeys,
                     buttons = conf.buttons.client } },
    { rule = { class = "mplayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
--    { rule = { class = "emacs" },
--      properties = { tag = conf.tags[2][2] } },
    { rule = { class = "firefox" },
      properties = { tag = conf.tags[1][1] } }
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}

dofile (conf.modules_dir .. 'rules.lua')

-- Setup client rules
dofile (conf.modules_dir .. 'client.lua')

-- }}}
