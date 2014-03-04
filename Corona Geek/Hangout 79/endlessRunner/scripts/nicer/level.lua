-- =============================================================
-- level.lua
-- =============================================================

-- Tip: As a (possibly) better solution for backscrolling, use a repeating fill with an offset: http://coronalabs.com/blog/2013/11/07/tutorial-repeating-fills-in-graphics-2-0/
--      Then, modify that offset dynamically over time.

----------------------------------------------------------------------
--	Requires
----------------------------------------------------------------------
local cc 		= require "scripts.nicer.cc"
local player	= require "scripts.nicer.player"


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

local gapWidth 				= 160
local gapHeight 			= minBuildingHeight

local parallaxSpeeds = {}

local distanceModifier = 0.25
local isRunning = false
local distanceMeter
local startTime


-- Forward Declarations
local create 
local destroy
local createSpawnTrigger
local createDestroyTrigger
local createTouchPad
local createBuilding
local createFirst 
local createNext

local createParallax
local createFirstParallax
local createNextParallax

local getTimer 	= system.getTimer
local mRand 	= math.random

-- Callbacks/Listeners
local onSpawnTrigger
local onDestroyTrigger
local onMeterUpdate

----------------------------------------------------------------------
-- Definitions
----------------------------------------------------------------------

-- All-in-one function to start off the whole show (creation wise)
--
create = function ( group, speed, offsetX )
	local group 	= group or display.getCurrentStage()

	physics.setGravity(0,30)

	local layers = display.newGroup()
	layers.pback = display.newGroup()
	layers.p3 = display.newGroup()
	layers.p2 = display.newGroup()
	layers.p1 = display.newGroup()
	layers.content = display.newGroup()

	group:insert( layers )
	layers:insert( layers.pback ) 
	layers:insert( layers.p1 )
	layers:insert( layers.p2 )
	layers:insert( layers.p3 )
	layers:insert( layers.content )

	if( speed ) then
		buildingSpeed = speed
	end

	parallaxSpeeds[1] = buildingSpeed * 0.025
	parallaxSpeeds[2] = buildingSpeed * 0.1
	parallaxSpeeds[3] = buildingSpeed * 0.2

	if( offsetX ) then
		triggerOffsetX = offsetX
	end

	createTouchPad( group )

	createFirst( layers.content )

	createSpawnTrigger( layers.content )

	createDestroyTrigger( layers.content )

	player.create( layers.content, buildingSpeed )

	local aParallaxLayer = display.newImageRect( layers.pback, "images/parallax/nightback.png", w, h)
	aParallaxLayer.x = centerX
	aParallaxLayer.y = centerY

	local moon = display.newImageRect( layers.pback, "images/parallax/moon.png", 120, 120)
	moon.x = w - 200
	moon.y = 125

	createFirstParallax( layers.p3, 3 )
	createFirstParallax( layers.p2, 2 )
	createFirstParallax( layers.p1, 1 )	

	distanceMeter = display.newText( layers.content, "Distance: 0", 100, 20, system.defaultFont, 22 )

	isRunning = true
	startTime = getTimer()

	Runtime:addEventListener( "enterFrame", onMeterUpdate )
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
	aGap:setFillColor(1,1,0,0)
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

	local aBuilding = display.newImageRect( group, "images/stone.jpg", buildingWidth, buildingHeight)
	aBuilding:setFillColor(0.8,0.8,0.8,1)
	aBuilding:setStrokeColor(0.8,0.8,0.8,1)
	aBuilding.strokeWidth = 2
	physics.addBody( aBuilding, "kinematic", { density=1, friction=0, bounce=0 ,filter=cc:getCollisionFilter("building") } )

	aBuilding.isSleepingAllowed = false
	--aBuilding.isBodyActive = true

	aBuilding.y = h - aBuilding.contentHeight/2
	
	aBuilding.isBuilding = true
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


-- This function creates a parallax layer
-- 
createParallax = function ( group, layerNum )
	local first = first or false

	local aParallaxLayer = display.newImageRect( group, "images/parallax/night" .. layerNum .. ".png", w, h)

	physics.addBody( aParallaxLayer, "kinematic", { density=1, friction=0, bounce=0 ,filter=cc:getCollisionFilter("parallax") } )

	aParallaxLayer.layerNum = layerNum

	aParallaxLayer.isSleepingAllowed = false

	aParallaxLayer.y = centerY	

	return aParallaxLayer
end

-- Create first building in level
--
createFirstParallax = function ( group, layerNum )
	local aParallaxLayer = createParallax( group, layerNum ) 

	aParallaxLayer.x = centerX

	aParallaxLayer:setLinearVelocity( -parallaxSpeeds[layerNum], 0 )
	
end

createNextParallax = function ( last )
	local aParallaxLayer = createParallax( last.parent, last.layerNum ) 

	aParallaxLayer.x = last.x + last.contentWidth/2 + aParallaxLayer.contentWidth/2
	
	aParallaxLayer:setLinearVelocity( -parallaxSpeeds[last.layerNum], 0 )	
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
	local other 		= event.other

	if( phase == "ended" ) then		

		if( other.isBuilding ) then
			timer.performWithDelay(1, 
				function() 
					createNext( other ) 
				end )
		
		else
			timer.performWithDelay(1, 
				function() 
					createNextParallax( other ) 
				end )
		end
	end
	return false
end

-- Listener for collisions with destroyer rectangle.
--
onDestroyTrigger = function( self, event )
	local phase 		= event.phase
	local theTrigger 	= self
	local other 	= event.other
	if( phase == "ended" ) then		
		timer.performWithDelay( 10, function() display.remove( other ) end )
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

		isRunning = false
		
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

-- Simple function to update meter
onMeterUpdate = function( event )
	if( not isRunning ) then
		Runtime:removeEventListener( "enterFrame", onMeterUpdate )
		return
	end

	local curTime = getTimer()

	distanceMeter.text = "Distance: " .. round( distanceModifier * buildingSpeed * (curTime - startTime)/1000 )
end

----------------------------------------------------------------------
-- Module Packaging
----------------------------------------------------------------------
public = {}
public.create 	= create
public.destroy 	= destroy
return public