-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

--[[
		This code demonstrates how to make objects of a specific 'type' collide with other objects of 
		specific types  while not colliding with other types.

		Specifically, these are the 'types' and rules for collisions./


		+ 'redface' 	- Collides with 'redface' and 'ground', but not 'greenface'
		+ 'greenface'   - Collides with 'ground' only.

		Specifically, 
			- 'redfaces' objects will collide with 'redfaces' and the square 'ground' objects.
			- 'bluefaces' objects will collide with 'bluefaces' and the square 'ground' objects.

--]]



--
-- 1. Load SSK OR Load the 'Collision Calculator' module alone.
--require "ssk.loadSSK" 
local ccmgr = require "RGCC"

--
-- 2. Require and start physics
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
--physics.setDrawMode( "hybrid" ) -- uncomment for debug rendering

-- 
-- 3. Create a calculator
local myCC = ccmgr:newCalculator()

--
-- 4. Add known 'named' types to calculator
myCC:addNames( "redface", "greenface", "ground" )

--
-- 5. Define collision rules (first named type, collides with ... list after it.)
myCC:collidesWith( "redface",     "redface", "ground" )
myCC:collidesWith( "greenface",   "ground" ) 


--
-- 6. Define functions to spawn face objects
local function spawnRedFace( x, y )
	local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
	tmp.x = x
	tmp.y = y
	tmp:setFillColor(1,0,0)

	physics.addBody( tmp, "dynamic", { filter = myCC:getCollisionFilter("redface"), radius = 20, bounce = 0.5 })

	timer.performWithDelay( 3000, function() spawnRedFace( x, y ) end ) -- spawn new object in 3 seconds

	timer.performWithDelay( 10000, function() display.remove(tmp) end ) -- destroy object in 10 seconds
end

local function spawnGreenFace( x, y )
	local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
	tmp.x = x
	tmp.y = y
	tmp:setFillColor(0,1,0)

	physics.addBody( tmp, "dynamic", { filter = myCC:getCollisionFilter("greenface"), radius = 20, bounce = 0.5, friction = 0 })

	timer.performWithDelay( 2000, function() spawnGreenFace( x, y ) end ) -- spawn new object in 2 seconds

	timer.performWithDelay( 3000, function() display.remove(tmp) end ) -- destroy object in 3 seconds
end

--
-- 7. Draw a ground
for i = 1, 24 do
	local tmp = display.newImageRect( "square.png", 40, 40 )
	tmp.x = 40 * i - 20
	tmp.y = display.contentCenterY + 200
	physics.addBody( tmp, "static", { filter = myCC:getCollisionFilter("ground") } )
end

local tmp = display.newImageRect( "square.png", 40, 40 )
tmp.x = 20
tmp.y = display.contentCenterY + 160
physics.addBody( tmp, "static", { filter = myCC:getCollisionFilter("ground") } )

local tmp = display.newImageRect( "square.png", 40, 40 )
tmp.x = 40 * 24 - 20
tmp.y = display.contentCenterY + 160
physics.addBody( tmp, "static", { filter = myCC:getCollisionFilter("ground") } )


-- 
-- 8. Start Dropping objects
spawnRedFace( display.contentCenterX - 200, display.contentCenterY - 100 )
spawnRedFace( display.contentCenterX - 180, display.contentCenterY - 150 )
spawnRedFace( display.contentCenterX - 200, display.contentCenterY - 200 )

spawnGreenFace( display.contentCenterX, display.contentCenterY - 100 )
spawnGreenFace( display.contentCenterX, display.contentCenterY - 150 )


	