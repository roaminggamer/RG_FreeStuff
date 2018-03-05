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
	layers = quickLayers( group, "background", "content", "enemies", "player", "interfaces" )
	--
	physics.start()
	physics.setGravity( 0, 10 )


	--
	-- The shake code
	--
	local shakeCount = 0
	local xShake = 8
	local yShake = 4
	local shakePeriod = 2

	local function shake()
		if(shakeCount % shakePeriod == 0 ) then
			display.currentStage.x = display.currentStage.x0 + math.random( -xShake, xShake )
			display.currentStage.y = display.currentStage.y0 + math.random( -yShake, yShake )
		end
		shakeCount = shakeCount + 1
	end

	local function startShake()
		display.currentStage.x0 = display.currentStage.x
		display.currentStage.y0 = display.currentStage.y
		shakeCount = 0
		Runtime:addEventListener( "enterFrame", shake )
	end
	local function stopShake()
		Runtime:removeEventListener( "enterFrame", shake )
		timer.performWithDelay( 50, 
			function()			
				display.currentStage.x = display.currentStage.x0 
				display.currentStage.y = display.currentStage.y0
			end )
		timer.performWithDelay( 250, 
			function()			
				print("STOPPED SHAKE: ", display.currentStage.x, display.currentStage.x0, display.currentStage.y, display.currentStage.y0 )
			end )		
	end	


	--
	-- Images and scene items to help visualize the effect
	--
	local back = display.newImageRect(layers.content, "images/askEd/hawaii_2014.jpg", 480, 320 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY
	back.alpha = 0.5

	local ground = display.newRect(layers.content,0,300,480,20)
	ground:setFillColor(0,1,0)
	ground.x = display.contentCenterX
	ground.y = centerY + 330/2
	physics.addBody( ground, "static", { bounce = 0 } )


	local ball = display.newCircle(layers.player, display.contentCenterX, centerY- 100, 20)
	ball:setFillColor(1,0,0)
	physics.addBody( ball, "dynamic", { radius = 20, bounce = 1 } )

	ball.collision = function( self, event )
		if( event.phase == "began" ) then
			startShake()
			timer.performWithDelay( 500, stopShake  )
		end
		return true
	end
	ball:addEventListener( "collision" )

	--physics.pause()
end

function game.start()
	isRunning = true
	physics.start()
end

function game.stop()
	isRunning = false
	physics.pause()
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



