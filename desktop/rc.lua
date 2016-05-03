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

-- {{{ Widgets
conf.widgets = {}
conf.widgets.clock = awful.widget.textclock()
conf.widgets.pass = pass.widget()
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
   { names = {'surf','connect','play','watch','create','monitor'},
     layout = {awful.layout.suit.max,
               awful.layout.suit.max,
               awful.layout.suit.max,
               awful.layout.suit.max,
               awful.layout.suit.floating,
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

-- {{{ Mouse Buttons
conf.buttons = {}
conf.buttons.taglist =
   awful.util.table.join(awful.button({ }, 1, awful.tag.viewonly),
                         awful.button({ modkey }, 1, awful.client.movetotag),
                         awful.button({ }, 2, awful.tag.viewtoggle),
                         awful.button({ modkey }, 2, awful.client.toggletag),
                         awful.button({ }, 3, function (t)
                               customization.func.tag_action_menu(t)
                         end),
                         awful.button({ modkey }, 3, awful.tag.delete),
                         awful.button({ }, 4, function(t)
                               awful.tag.viewprev(awful.tag.getscreen(t)) end),
                         awful.button({ }, 5, function(t)
                               awful.tag.viewnext(awful.tag.getscreen(t)) end))
conf.buttons.tasklist =
   awful.util.table.join(
      
      awful.button({ }, 1, function (c)
            if c == client.focus then
               c.minimized = true
            else
               -- Without this, the following
               -- :isvisible() makes no sense
               c.minimized = false
               if not c:isvisible() then
                  awful.tag.viewonly(c:tags()[1])
               end
               -- This will also un-minimize
               -- the client, if needed
               client.focus = c
               c:raise()
            end
      end),

--      awful.button({ }, 2, function (c)
--            customization.func.clients_on_tag()
--      end),

--      awful.button({ modkey }, 2, function (c)
--            customization.func.all_clients()
--      end),

--      awful.button({ }, 3, function (c)
--            customization.func.client_action_menu(c)
--      end),

      awful.button({ }, 4, function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
      end),

      awful.button({ }, 5, function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
            end))
-- }}}

-- Setup the screens
dofile ('/home/thartman/projects/awesomerc/modules/screens.lua')

-- Setup the menus
dofile ('/home/thartman/projects/awesomerc/modules/menu.lua')

-- Setup the keys mappings
dofile ('/home/thartman/projects/awesomerc/modules/keys.lua')

-- Setup mouse bindings
dofile ('/home/thartman/projects/awesomerc/modules/mouse.lua')

-- Setup the windowing rules
dofile ('/home/thartman/projects/awesomerc/modules/rules.lua')
