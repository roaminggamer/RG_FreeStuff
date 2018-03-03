-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local root 	  = "answerpath"
local baseDir = system.DocumentsDirectory
-- =============================================================
local hCommon		= require "scripts.common" -- Harness Common
local physics 		= require "physics"

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mAbs					= math.abs
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale

local RGTiled = ssk.tiled
local newText = display.newText

-- =============================================================
-- Locals
-- =============================================================
local layers
local lastTimer
local isRunning 

-- =============================================================
-- Module Begins
-- =============================================================
local game = {}

function game.create( group, params )
	group = group or display.currentStage
	params = params or {}
	--
	isRunning = false
	--
	display.remove( layers )
	--
	layers = display.newGroup()
	group:insert(layers)
	--
	physics.start()
	physics.setGravity( 0, 10 )

	local allBalloons = {}

	local function onTouch( self, event )
		allBalloons[self] = nil
		display.remove(self)
		return true
	end

	local function createBalloon( )

		if( not isRunning ) then return end

		-- Randomly create one of five balloon images
		local imgNum = math.random( 1, 5 )	
		local tmp = display.newImageRect( layers, "images/balloons/balloon" .. imgNum .. ".png", 295/3, 482/3 )	

		-- Randomly place the balloon
		tmp.y = top-50
		tmp.x = math.random( left+50, right - 50 )

		-- Scale it to make a 'smaller' balloon
		--tmp:scale( 0.1, 0.1 )

		-- add a touch listener
		tmp.touch = onTouch
		tmp:addEventListener( "touch" )

		-- Give it a body so 'gravity' can pull on it
		physics.addBody( tmp, { radius = tmp.contentWidth/2} )

		-- Give the body a random rotation
		tmp.angularVelocity = math.random( -180, 180 )

		-- Give it drag so it doesn't accelerate too fast
		tmp.linearDamping = 1

		-- Self destruct in 5 seconds
		timer.performWithDelay( 5000,
			function()
				allBalloons[tmp] = nil
				display.remove( tmp )
			end )
	end


	-- Create a new baloon every 1/2 second  forever
	lastTimer = timer.performWithDelay( 500, createBalloon, -1  )
	
	--physics.pause()
end

function game.start()
	isRunning = true
	--physics.start()
end

function game.stop()
	isRunning = false
	--physics.pause()
end

function game.destroy()
	game.stop()
	--
	if( lastTimer ) then
		timer.cancel(lastTimer)
		lastTimer = nil
	end	
	--
	display.remove( layers )
	layers = nil
end

return game



