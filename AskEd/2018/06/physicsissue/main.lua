io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
physics.setDrawMode("hybrid")
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end

-- =====================================================
-- YOUR CODE BELOW
-- =====================================================
local function original()
	local _T  = display.screenOriginY
	local _B  = display.viewableContentHeight - display.screenOriginY
	local _L  = display.screenOriginX
	local _R  = display.viewableContentWidth - display.screenOriginX
	local _CX = display.contentCenterX
	local _CY = display.contentCenterY

	local platform = display.newImageRect( "fillW.png", 300, 50 )
	platform.x = _CX
	platform.y = _B-25

	local rect = display.newRect(  200, 100, 100, 300 )
	print( _CX, _B- 120, _L - _R, 20 )
	local bottomWall = display.newRect( _CX, _B- 120, _L - _R, 20 )

	physics.addBody( platform, "static" )
	physics.addBody( rect, "dynamic", { bounce=0.3 } )
	physics.addBody( bottomWall, "static" )
end

local function alt()
	local cx     = display.contentCenterX
	local cy     = display.contentCenterY
	local fullw  = display.actualContentWidth
	local fullh  = display.actualContentHeight
	local left   = cx - fullw/2
	local right  = cx + fullw/2
	local top    = cy - fullh/2
	local bottom = cy + fullh/2

   local platform = display.newImageRect( "fillW.png", 300, 50 )
   platform.x = cx
   platform.y = bottom - 25

   local rect = display.newRect( 200, 100, 100, 300 )
   print( cx, bottom - 120, fullw, 20 )
   local bottomWall = display.newRect( cx, bottom - 120, fullw, 20 )

	physics.addBody( platform, "static" )
	physics.addBody( rect, "dynamic", { bounce=0.3 } )
	physics.addBody( bottomWall, "static" )
end

original()
--alt()
