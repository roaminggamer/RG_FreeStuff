-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Local Variables
local centerX		= display.contentCenterX
local centerY		= display.contentCenterY
local w				= display.contentWidth


local physics = require("physics")
physics.start()
physics.setGravity(9.8,0)
--physics.setDrawMode( "hybrid" )


local createBlock

createBlock = function()
	local block = display.newRect( group, 0,0,40,40 )
	block.x = w/4
	block.y = centerY-20
	physics.addBody( block, "dynamic", { } )

	timer.performWithDelay( 1000, createBlock )
end

createBlock()



return group
