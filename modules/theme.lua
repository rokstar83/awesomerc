-- {{{ Main theme definition
theme = {}
-- }}}

-- {{{ font
theme.font = "terminus 8"
-- }}}

-- {{{ Colors
theme.fb_normal  = "#DCDCCCFF"
theme.fb_focus   = "#F0DFAFFF"
theme.fb_urgent  = "#CC9393FF"
theme.bg_normal  = "#00000000"
theme.bg_focus   = "#1E232099"
theme.bg_urgent  = "#3F3F3FFF"
theme.bg_systray = theme.bg_normal

-- {{{ Border
theme.border_width = 2
theme.border_normal = theme.bg_normal
theme.border_marked = theme.bg_urgent
theme.border_focus = bg_focus
theme.border_normal = bg_normal
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3FFF"
--theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393FF"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 15
theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = "/usr/share/awesome/themes/zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/zenburn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Layout
theme.layout_tile       = "/usr/share/awesome/themes/zenburn/layouts/tile.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/zenburn/layouts/tileleft.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/zenburn/layouts/tilebottom.png"
theme.layout_tiletop    = "/usr/share/awesome/themes/zenburn/layouts/tiletop.png"
theme.layout_fairv      = "/usr/share/awesome/themes/zenburn/layouts/fairv.png"
theme.layout_fairh      = "/usr/share/awesome/themes/zenburn/layouts/fairh.png"
theme.layout_spiral     = "/usr/share/awesome/themes/zenburn/layouts/spiral.png"
theme.layout_dwindle    = "/usr/share/awesome/themes/zenburn/layouts/dwindle.png"
theme.layout_max        = "/usr/share/awesome/themes/zenburn/layouts/max.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/zenburn/layouts/fullscreen.png"
theme.layout_magnifier  = "/usr/share/awesome/themes/zenburn/layouts/magnifier.png"
theme.layout_floating   = "/usr/share/awesome/themes/zenburn/layouts/floating.png"
-- }}}
-- }}}

return theme
