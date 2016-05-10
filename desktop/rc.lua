-- Config file for Awesome
local awful = require('awful')
local pass = dofile ('/home/thartman/projects/awesome-pass/awesome-pass.lua')

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
--local beautiful = require('beautiful')
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
conf.widgets.clock = awful.widget.textclock()
conf.widgets.pass = pass()
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
-- }}}

-- {{{ custom keybindings
conf.keys = {}
conf.keys.global = {
   { { modkey }, "F12", conf.func.system_lock },
   --   { { modkey }, "c"  , function () os.execute("xsel -p -i | xsel - i -b") end},
   { { modkey }, "Print",
      function () os.execute("scrot -e 'mv $f " .. conf.dirs.screenshots ..
                             " 2>/dev/null'" ) end},
}

-- }}}

-- Setup the keys mappings
dofile ('/home/thartman/projects/awesomerc/modules/keys.lua')

-- Setup mouse bindings
dofile ('/home/thartman/projects/awesomerc/modules/mouse.lua')

-- Setup the screens
dofile ('/home/thartman/projects/awesomerc/modules/screens.lua')

-- Setup the menus
dofile ('/home/thartman/projects/awesomerc/modules/menu.lua')

-- Setup the windowing rules
dofile ('/home/thartman/projects/awesomerc/modules/rules.lua')

-- Setup client rules
dofile ('/home/thartman/projects/awesomerc/modules/client.lua')
