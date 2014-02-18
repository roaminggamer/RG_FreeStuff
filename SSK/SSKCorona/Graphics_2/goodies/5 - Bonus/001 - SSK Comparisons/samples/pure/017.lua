-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()


-- NOTE!!!!!
--
-- FOLLOWING CODE COMMENTED OUT BECAUSE RUNNING BOTH PURE AND SSK 
-- WILL CAUSE COLLISIONS BETWEEN THE SAMPLES.
--
-- THIS CODE DOES THE SAME THING AS THE SSK VERSION
--

--[[
local physics = require("physics")
physics.start()
physics.setGravity(0,9.8)
--physics.setDrawMode( "hybrid" )

local createBlock
local createBall

-- Manually Calculate Collision Filters
--
-- Category Bits:
--                block      = 1
--                red ball   = 2
--                green ball = 4
--
-- Mask Bits:
--                block      = 2 
--                red ball   = 1
--                green ball = 0

createBall = function( x, y, r, color, type)
	local circle = display.newCircle( group, x, y, r )

	if( type == "red" ) then
		circle:setFillColor( 255,0,0 )
		
		local collsionFilter = { categoryBits = 2,  maskBits = 1 }
		
		physics.addBody( circle, { bodyType = "dynamic", filter = collsionFilter, bounce = 1.0, density = 1, radius = r, friction = 0.7 } )
	else
		circle:setFillColor( 0,255,0 )
		
		local collsionFilter = { categoryBits = 4,  maskBits = 0 }
		
		physics.addBody( circle, "dynamic", { filter = collsionFilter, bounce = 1.0, density = 1, radius = r, friction = 0.7 } )

	end 
	
	timer.performWithDelay( 1000, function() createBall(x, y, r, color, type) end )
end


createBlock = function( x, y, size, angle)
	local rect = display.newRect( group, 0,0, size, size )
	rect.x = x
	rect.y = y

	rect.rotation = angle

	local collsionFilter = { categoryBits = 1,  maskBits = 2 }

	physics.addBody( rect, "static",  {filter = collsionFilter, friction = 0.7 } )
end

createBlock( centerX - 100, h - 50, 80, 10)
createBlock( centerX + 100, h - 50, 80, 0)


createBall( centerX - 100, 30, 20, _RED_, "red" )
createBall( centerX + 100, 30, 20, _GREEN_, "green" )

--]]


return group
