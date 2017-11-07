-------------------------------------------------------------------------------
-- tools.lua for Tools for Awesome Configuration                             --
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

--- tools -- {{{
local tools = {}

tools.terminal_cmd       = 'urxvt'
tools.compmgr_cmd        = 'xcompmgr'
tools.compmgr_cmdopts    = '-f -c -s'
tools.filemanager_cmd    = 'mc'
tools.browser_cmd        = os.getenv('BROWSER') or 'firefox'
tools.editor_cmd         = os.getenv('EDITOR') or 'et'
tools.screenlock_cmd     = 'xscreensaver-command'
tools.screenlock_cmdopts = '-l'
tools.background_cmd     = 'nitrogen'
tools.background_cmdopts = '--restore'

--- DEBUG -- {{{
if conf.debug then
   print("Custom tools loaded")
end
-- }}}

return tools
-- }}}
