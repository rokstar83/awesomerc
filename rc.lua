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

--- Theme -- {{{
conf.theme = conf.config_dir .. 'theme.lua'
beautiful.init(conf.theme)
-- }}}

--- Tools -- {{{
conf.tools = require('tools')
-- }}}

--- Functions -- {{{
conf.functions = require('functions')
-- }}}

--- Mouse -- {{{
conf.mouse = require('mouse')
-- }}}

--- Rules -- {{{
conf.rules = require('rules')
-- }}}

--- Client -- {{{
conf.client = require('client')
-- }}}


conf.keys = require('keys')
conf.menu = require('menu')


--- Finalize -- {{{
root.keys(conf.global)
-- }}}

-- }}}
