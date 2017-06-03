io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local centerX  = display.contentCenterX
local centerY  = display.contentCenterY
local fullw 	= display.actualContentWidth
local fullh 	= display.actualContentHeight
local left 		= centerX - fullw/2
local right 	= left + fullw
local top 		= centerY - fullh/2
local bottom 	= top + fullh

local dockM = require "dock"

--
-- Dock 1 Example
--
local dock1 = dockM.createLeftDock( nil, top + fullh/4, 300, fullh/2 )

local tmp = display.newRect( dock1.group, 0, 0, 10000, 10000 )
tmp:setFillColor( 0, 0.5, 0.5 )
function tmp.touch( self, event )
	if( event.phase == "ended" ) then
		dock1:hide( 250 )
	end
	return true
end; tmp:addEventListener( "touch", tmp )

local tmp = display.newImageRect( dock1.group, "images/bug.png", 100, 100 )
tmp.x = dock1.contentWidth/2
tmp.y = dock1.contentHeight/2


--
-- Dock 2 Example
--
local dock2 = dockM.createLeftDock( nil, bottom - fullh/4, 400, fullh/2 )

local tmp = display.newRect( dock2.group, 0, 0, 10000, 10000 )
tmp:setFillColor( 0.25, 0.5, 0.25 )
function tmp.touch( self, event )
	if( event.phase == "ended" ) then
		dock2:hide( 250 )
	end
	return true
end; tmp:addEventListener( "touch", tmp )

local tmp = display.newImageRect( dock2.group, "images/star.png", 100, 100 )
tmp.x = dock2.contentWidth/2
tmp.y = dock2.contentHeight/2




local function onTouch( event )
	if( event.phase == "ended" ) then
		dock1:show( 750 )
		dock2:show( 750 )
	end
end
Runtime:addEventListener("touch",onTouch)