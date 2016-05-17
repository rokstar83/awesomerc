-- Config file for Awesome
local awful = require('awful')
local pass = require('awesome-pass')
local wibox = require('wibox')

-- temp
pass.pass_icon = '/home/thartman/projects/awesome-pass/icons/pass.png'

-- {{{ Awful config
awful.client = require('awful.client')
awful.screen = require('awful.screen')
awful.rules = require ('awful.rules')
awful.menu = require('awful.menu')
-- }}}

modkey = 'Mod4'

-- {{{ The conf array contains and controls all elements for configuring awesome 
conf = {}
-- }}}

-- {{{ Awesome theme
conf.theme = '/home/thartman/projects/awesomerc/modules/theme.lua'
local beautiful = require('beautiful')
--beautiful.init(conf.theme)
-- }}}

-- {{{ Functions
conf.func = dofile ('/home/thartman/projects/awesomerc/modules/functions.lua')
-- }}}

-- {{{ Default tools and programs
conf.tools = {}
conf.tools.terminal_cmd = 'urxvt'
conf.tools.compmgr_cmd = 'xcompmgr'
conf.tools.compmgr_cmdopts = '-f -c -s'
conf.tools.filemanager_cmd = 'mc'
conf.tools.browser_cmd = os.getenv('BROWSER') or 'firefox'
conf.tools.editor_cmd = os.getenv('EDITOR') or 'et'
conf.tools.screenlock_cmd = 'xscreensaver-command -l'
conf.tools.background_cmd = 'nitrogen'
conf.tools.background_cmdopts = '--restore'
-- }}}

-- {{{ Default directories
conf.dirs = {}
conf.dirs.screenshots = "~/pictures/screenshots/"
-- }}}

-- {{{ Widgets
conf.widgets = {}

-- conf.widgets.spacer = wibox.widget.textbox()
-- conf.widgets.spacer:set_text(" | ")

conf.widgets.clock = awful.widget.textclock()

local base = wibox.widget.textbox()
base:set_text("pass")
conf.widgets.pass = pass(base)
-- }}}

-- {{{ custom keybindings
conf.keys = {}
conf.keys.global = {
   { { modkey }, "F12", conf.func.system_lock },
   --   { { modkey }, "c"  , function () os.execute("xsel -p -i | xsel - i -b") end},
   { { modkey }, "Print",
      function () os.execute("scrot -e 'mv $f " .. conf.dirs.screenshots ..
                             " 2>/dev/null'" ) end},
   { { modkey }, "p", function () conf.widgets.pass:toggle_pass_show() end}
}

dofile ('/home/thartman/projects/awesomerc/modules/keys.lua')

dofile ('/home/thartman/projects/awesomerc/modules/mouse.lua')
-- }}}

-- {{{ Screen Tags and Layouts
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

conf.screens[1].widgets = {conf.widgets.pass,
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

dofile ('/home/thartman/projects/awesomerc/modules/screens.lua')
-- }}}

-- {{{ Menu customization
conf.menus = {}
conf.menus.sys = {
   { '&lock'     , conf.func.system_lock },
   { '&reboot'   , conf.func.reboot      },
   { '&shutdown' , conf.func.shutdown    },
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

dofile ('/home/thartman/projects/awesomerc/modules/menu.lua')
-- }}}

-- {{{ custom rules
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
    { rule = { class = "emacs" },
      properties = { tag = conf.tags[2][2] } },
    { rule = { class = "firefox" },
      properties = { tag = conf.tags[1][1] } }
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}

dofile ('/home/thartman/projects/awesomerc/modules/rules.lua')
-- }}}

-- Setup client rules
dofile ('/home/thartman/projects/awesomerc/modules/client.lua')
