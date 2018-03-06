io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
-- == Uncomment following lines if you need  physics
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")

local function createWalls( wallWidth )
	local fullw   = display.actualContentWidth
	local fullh   = display.actualContentHeight
	local centerX = display.contentCenterX
	local centerY = display.contentCenterY

	local leftWall = display.newRect( centerX - fullw/2 + wallWidth/2, centerY, wallWidth, fullh )
	leftWall:setFillColor(1,0,0)
   physics.addBody( leftWall, "static", {bounce = 0.0, friction = 2} )

	local rightWall = display.newRect( centerX + fullw/2 - wallWidth/2, centerY, wallWidth, fullh )
	rightWall:setFillColor(0,1,0)
   physics.addBody( rightWall, "static", {bounce = 0.0, friction = 2} )

	local topWall = display.newRect( centerX, centerY - fullh/2 + wallWidth/2, fullw  - 2 * wallWidth, wallWidth )
	topWall:setFillColor(0,0,1)
   physics.addBody( topWall, "static", {bounce = 0.0, friction = 2} )

	local bottomWall = display.newRect( centerX, centerY + fullh/2 - wallWidth/2, fullw - 2 * wallWidth, wallWidth )
	bottomWall:setFillColor(1,1,0)
   physics.addBody( bottomWall, "static", {bounce = 0.0, friction = 2} )
end

createWalls( 40 )