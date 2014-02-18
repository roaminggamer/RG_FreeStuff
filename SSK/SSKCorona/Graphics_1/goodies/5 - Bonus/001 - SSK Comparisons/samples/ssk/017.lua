-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup() 


local physics = require("physics")
physics.start()
physics.setGravity(0,9.8)
--physics.setDrawMode( "hybrid" )

local createBlock
local createBall

-- Easily set up collision filters with an SSK Collision Calculator
local myCC = ssk.ccmgr:newCalculator()
myCC:addNames( "block", "redBall", "greenBall" )
myCC:collidesWith( "redBall", "block"  )

createBall = function( x, y, r, color, type)
	ssk.display.circle( group, x, y, 
	                    {fill = color, radius = r}, 
	                    { calculator = myCC, colliderName = type, bounce = 1.0} )
	
	timer.performWithDelay( 1000, function() createBall(x, y, r, color, type) end )
end


createBlock = function( x, y, size, angle)
	ssk.display.rect( group, x, y, 
	                  {size = size, rotation = angle}, 
					  { calculator = myCC, colliderName = "block", bodyType = "static"} )
end

createBlock( centerX - 100, h - 50, 80, 10)
createBlock( centerX + 100, h - 50, 80, 0)


createBall( centerX - 100, 30, 20, _RED_, "redBall" )
createBall( centerX + 100, 30, 20, _GREEN_, "greenBall" )


-- Follwoing offset accounts for way harness runs this sample...
group.y = group.y - h/3

myCC:dump()
return group
