-- =============================================================
-- level.lua
-- =============================================================

----------------------------------------------------------------------
--	Requires
----------------------------------------------------------------------
local cc 		= require "scripts.cc"
local player	= require "scripts.player"


----------------------------------------------------------------------
-- Declarations
----------------------------------------------------------------------
-- Locals
local triggerOffsetX 		= -80

local buildingSpeed 		= 50
local minBuildingWidth		= 3 * w / 5
local maxBuildingWidth		= 1.5 * w

local minBuildingHeight  	= 70
local maxBuildingHeight 	= 150

local startBuildingHeight	= 80
local startBuildingWidth	= w

local gapWidth 				= 80
local gapHeight 			= minBuildingHeight


-- Forward Declarations
local create 
local destroy
local createSpawnTrigger
local createDestroyTrigger
local createTouchPad
local createBuilding
local createFirst 
local createNext

local getTimer 	= system.getTimer
local mRand 	= math.random

-- Callbacks/Listeners
local onSpawnTrigger
local onDestroyTrigger

----------------------------------------------------------------------
-- Definitions
----------------------------------------------------------------------

-- All-in-one function to start off the whole show (creation wise)
--
create = function ( group, speed, offsetX )
	local group 	= group or display.getCurrentStage()

	physics.setGravity(0,20)

	if( speed ) then
		buildingSpeed = speed
	end

	if( offsetX ) then
		triggerOffsetX = offsetX
	end

	createFirst( group )

	createSpawnTrigger( group )

	createDestroyTrigger( group )

	player.create( group )
end


-- This function creates a physics object that will be used to detect the proper time
-- to spawn a new building.
-- 
-- Disadvantage(s) - Uses physics and that costs some CPU time.  Complex if you are new to physics.
-- Advantage(s) - Simple if you are experienced with physics, and consistent behavior on all devices.
-- Alternartive - Use a timer.  (Not consistent on all devices.)
-- 
createSpawnTrigger = function ( group )
	local spawnTrigger = display.newRect( group, 0, 0, 20, h)
	spawnTrigger:setFillColor(0,0,1,0.5)
	spawnTrigger.x = w - triggerOffsetX
	spawnTrigger.y = centerY	
	physics.addBody( spawnTrigger, "dynamic", { density=1, friction=0, bounce=0, filter=cc:getCollisionFilter("spawnTrigger") } )
	spawnTrigger.gravityScale = 0
	spawnTrigger.isSensor = true
	spawnTrigger.isSleepingAllowed = false
	--spawnTrigger.isBodyActive = true

	spawnTrigger.collision = onSpawnTrigger
	spawnTrigger:addEventListener( "collision" )
end

-- This function creates a physics object that will be used to detect the proper time
-- to destroy a  building.
-- 
createDestroyTrigger = function ( group )
	local destroyTrigger = display.newRect( group, 0, 0, 20, h)
	destroyTrigger:setFillColor(1,0,0,0.5)
	destroyTrigger.x = triggerOffsetX
	destroyTrigger.y = centerY	
	physics.addBody( destroyTrigger, "dynamic", { density=1, friction=0, bounce=0, filter=cc:getCollisionFilter("destroyTrigger") } )
	destroyTrigger.gravityScale = 0
	destroyTrigger.isSensor = true
	destroyTrigger.isSleepingAllowed = false
	--destroyTrigger.isBodyActive = true

	destroyTrigger.collision = onDestroyTrigger
	destroyTrigger:addEventListener( "collision" )
end

-- This function creates a generic gap trigger
-- 
createGapTrigger  = function ( group )	
	local aGap = display.newRect( group, 0, 0, gapWidth, gapHeight )
	aGap:setFillColor(1,1,0,0.5)
	physics.addBody( aGap, "kinematic", { density=1, friction=0, bounce=0, filter=cc:getCollisionFilter("gapTrigger") } )

	aGap.isSensor = true
	aGap.isSleepingAllowed = false
	--aGap.isBodyActive = true

	aGap.y = h - aGap.contentHeight/2
	
	aGap.collision = onGapTrigger
	aGap:addEventListener( "collision" )

	return aGap
end


-- This  is used ot create a touchable rectangle to take taps.
--
-- Advantage - Deleting object deletes listener with no extra work.
-- Alternative - Use Runtime:addEventListener( "touch", someListenerFunction )
-- 
createTouchPad  = function ( group )
	local touchPad = display.newImageRect( group, "images/fillT.png",w, h)
	touchPad.x = centerX
	touchPad.y = centerY
	touchPad.touch = function ( self, event )
		if( event.phase == "ended") then
			post("onJump")
		end
		return true
	end
	touchPad:addEventListener( "touch" )

	return touchPad
end

-- This function creates a generic building
-- 
createBuilding  = function ( group, first )
	local first = first or false

	local buildingHeight = mRand( minBuildingHeight, maxBuildingHeight )
	local buildingWidth  = mRand( minBuildingWidth, maxBuildingWidth )
	if( first ) then
		buildingHeight = startBuildingHeight
		buildingWidth  = startBuildingWidth
	end

	local aBuilding = display.newRect( group, 0, 0, buildingWidth, buildingHeight)
	aBuilding:setFillColor(0,0,0,0)
	aBuilding:setStrokeColor( 0,1,0 )
	aBuilding.strokeWidth = 2
	physics.addBody( aBuilding, "kinematic", { density=1, friction=0, bounce=0 ,filter=cc:getCollisionFilter("building") } )

	aBuilding.isSleepingAllowed = false
	--aBuilding.isBodyActive = true


	aBuilding.y = h - aBuilding.contentHeight/2
	
	return aBuilding
end

-- Create first building in level
--
createFirst = function ( group )
	createTouchPad( group )

	local aBuilding = createBuilding( group, true ) 

	aBuilding.x = centerX

	aBuilding:setLinearVelocity( -buildingSpeed, 0 )
	
end

-- Create next building and gap in level
createNext = function ( last )
	local aBuilding = createBuilding( last.parent, false ) 
	local aGap = createGapTrigger( last.parent )	

	aBuilding.x = last.x + last.contentWidth/2 + aBuilding.contentWidth/2 + gapWidth 
	aGap.x = aBuilding.x - aBuilding.contentWidth/2 - aGap.contentWidth/2

	aBuilding:setLinearVelocity( -buildingSpeed, 0 )
	aGap:setLinearVelocity( -buildingSpeed, 0 )
end



-- Placeholder for a clean-up function to destroy whole level.
--
destroy = function ( group )
end


-- Listener for collisions with spawner rectangle.
--
onSpawnTrigger = function( self, event )
	local phase 		= event.phase
	local theTrigger 	= self
	local theBuilding 	= event.other

	if( phase == "ended" ) then		
		timer.performWithDelay(1, 
			function() 
				createNext( theBuilding ) 
			end )		
	end
	return false
end

-- Listener for collisions with destroyer rectangle.
--
onDestroyTrigger = function( self, event )
	local phase 		= event.phase
	local theTrigger 	= self
	local theBuilding 	= event.other
	if( phase == "ended" ) then		
		timer.performWithDelay( 10, function() display.remove( theBuilding ) end )
	end
	return false
end

-- Listener for collisions with gap rectangles.
--
onGapTrigger = function( self, event )
	if( not event.other.isPlayer ) then return true end

	local phase 		= event.phase
	local theTrigger 	= self
	local thePlayer 	= event.other
	if( phase == "began" ) then		
		timer.performWithDelay( 250, 
			function() 
				print("KILL")
				display.remove( thePlayer.foot ) 
				display.remove( thePlayer ) 
				local tmp = display.newText( "GAME OVER!", 0, 0, system.defaultFont, 30)
				tmp.x = centerX
				tmp.y = centerY - 20
				local tmp = display.newText( "RELOAD TO RESTART", 0, 0, system.defaultFont, 30)
				tmp.x = centerX
				tmp.y = centerY + 20
			end )
	end
	return false
end

----------------------------------------------------------------------
-- Module Packaging
----------------------------------------------------------------------
public = {}
public.create 	= create
public.destroy 	= destroy
return public