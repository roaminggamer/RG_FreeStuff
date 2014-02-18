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

createBlock = function ()
	ssk.display.rect( group, w/4, centerY+20, {}, {} )

	timer.performWithDelay( 1000, createBlock )
end

createBlock()


return group
