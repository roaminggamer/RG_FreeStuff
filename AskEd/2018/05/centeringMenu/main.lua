io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end

-- =====================================================
-- ANSWER BELOW
-- =====================================================
local group_title = display.newGroup()

local title = display.newText( "TITLE", 0, 0, native.systemFont, 16 )
title.x = display.contentCenterX 
title.y = 0
title:setFillColor( 0, .7, 0 )
title.anchorX = .5

local title_line = display.newLine(0, 16, display.contentWidth, 16)
title_line.anchorX = 0

group_title.anchorX = 0
group_title.anchorY = 0
group_title.anchorChildren = true 

group_title:insert(title) 
group_title:insert(title_line)

local group_menu = display.newGroup()

local menu_file = display.newText("File", 0,0,native.systemFont,16)
menu_file.anchorX = 0
menu_file.x = 10 
menu_file.y = 0
menu_file:setFillColor( .8, .3, 0 )

local menu_windows = display.newText("Wins", 0,0,native.systemFont,16)
menu_windows.anchorX = 0
menu_windows.x = menu_file.x + 40 
menu_windows.y = 0
menu_windows:setFillColor( .8, .3, 0 )

local menu_doors = display.newText("Doors", 0,0,native.systemFont,16)
menu_doors.anchorX = 0
menu_doors.x = menu_windows.x + 50 
menu_doors.y = 0
menu_doors:setFillColor( .8, .3, 0 )

local menu_base = display.newText("Base", 0,0,native.systemFont,16)
menu_base.anchorX = 0
menu_base.x = menu_doors.x + 55 
menu_base.y = 0
menu_base:setFillColor( .8, .3, 0 )

local menu_misc = display.newText("Misc", 0,0,native.systemFont,16)
menu_misc.anchorX = 0
menu_misc.x = menu_base.x + 50 
menu_misc.y = 0
menu_misc:setFillColor( .8, .3, 0 )

local menu_line = display.newLine(0, 16, display.contentWidth, 16)
menu_line.anchorX = 0

group_menu:insert(menu_file)
group_menu:insert(menu_windows)
group_menu:insert(menu_doors)
group_menu:insert(menu_base)
group_menu:insert(menu_misc)
group_menu:insert(menu_line)
group_menu.anchorX = .5
group_menu.x = 0 
group_menu.y = group_title.y + 40