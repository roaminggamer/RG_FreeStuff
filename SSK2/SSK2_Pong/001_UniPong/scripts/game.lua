-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- game.lua - Game Module
-- =============================================================
local common 		= require "scripts.common"
local factoryMgr 	= ssk.factoryMgr
local physics 		= require "physics"
local myCC 			= require "scripts.myCC"
local soundMgr		= ssk.soundMgr


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
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale


local RGTiled = ssk.tiled

-- =============================================================
-- Locals
-- =============================================================
local layers

-- =============================================================
-- Module Begins
-- =============================================================
local game = {}


-- ==
--    init() - One-time initialization only.
-- ==
function game.init()

	--
	-- Mark game as not running
	--
	common.gameIsRunning = false

	--
	-- Initialize all factories
	--
	factoryMgr.init()

	--
	-- Trick: Start physics, then immediately pause it.
	-- Now it is ready for future interactions/settings.
	physics.start()
	physics.pause()

	-- Clear Score, Couins, Distance Counters
	common.score 		= 0
end


-- ==
--    stop() - Stop game if it is running.
-- ==
function game.stop()
 
	--
	-- Mark game as not running
	--
	common.gameIsRunning = false

	--
	-- Pause Physics
	physics.setDrawMode("normal")	
	physics.pause()
end

-- ==
--    destroy() - Remove all game content.
-- ==
function game.destroy() 
	--
	-- Reset all of the factories
	--
	factoryMgr.reset( )

	-- Destroy Existing Layers
	if( layers ) then
		ignoreList( { "onDied" }, layers )
		display.remove( layers )
		layers = nil
	end

	-- Clear Score, Couins, Distance Counters
	common.score 		= 0
	common.coins 		= 0
	common.distance 	= 0
end


-- ==
--    start() - Start game actually running.
-- ==
function game.start( group, params )
	params = params or { debugEn = false }

	game.destroy() 

	--
	-- Mark game as running
	--
	common.gameIsRunning = true

	--
	-- Configure Physics
	--
	physics.start()
	physics.setGravity( common.gravityX, common.gravityY )
	if( params.hybridEn ) then
		physics.setDrawMode("hybrid")	
	end

	--
	-- Create Layers
	--
	layers = ssk.display.quickLayers( group, 
		"underlay", 
		"world", 
			{ "background", "content", "foreground" },
		"interfaces" )

	--
	-- Create a background color	
	--
	newRect( layers.underlay, centerX, centerY, 
		      { w = fullw, h = fullh, fill = common.backFill1 })

	--
	-- Create One Touch Easy Input
	--
	ssk.easyInputs.oneTouch.create(layers.underlay, { debugEn = params.debugEn, keyboardEn = true } )
	--ssk.easyInputs.twoTouch.create(layers.underlay, { debugEn = params.debugEn, keyboardEn = true } )
	--ssk.easyInputs.oneStick.create( layers.underlay, { debugEn = true, joyParams = { doNorm = true } } )
	--ssk.easyInputs.twoStick.create( layers.underlay, { debugEn = true, joyParams = { doNorm = true } } )
	--ssk.easyInputs.oneStickOneTouch.create( layers.underlay, { debugEn = true, joyParams = { doNorm = true } } )


	--
	-- Create HUDs
	--
	factoryMgr.new( "scoreHUD", layers.interfaces, centerX, top + 80 )
 
	--
	--
	-- Add player died listener to layers to allow it to do work if we need it
	function layers.onDied( self, event  )

		-- SSK2 PRO users have sound manager
		if( soundMgr ) then
			post( "onSound", { sound = "died" } )
		end


		ignore( "onDied", self )
		game.stop()	
		--
		-- Blur the whole screen
		--
		local function startOver()
			game.start( group, params )  
		end
		ssk.misc.easyBlur( layers.interfaces, 250, common.red, 
			                { touchEn = true, onComplete = startOver } )


		-- 
		-- Show 'You Died' Message
		--
		local msg1 = easyIFC:quickLabel( layers.interfaces, "Game Over!", centerX, centerY - 50, ssk.gameFont(), 50 )
		local msg2 = easyIFC:quickLabel( layers.interfaces, "Tap To Play Again", centerX, centerY + 50, ssk.gameFont(), 50 )
		easyIFC.easyFlyIn( msg1, { sox = -fullw, delay = 500, time = 750, myEasing = easing.outElastic } )
		easyIFC.easyFlyIn( msg2, { sox = fullw, delay = 500, time = 750, myEasing = easing.outElastic } )

	end; listen( "onDied", layers )
	--post("onDied")


	-- 
	-- Draw Walls
	--
	local lw = newRect( layers.content, left, centerY,
								{ w = 40, h = fullh, anchorX = 0, 
								  fill = common.backFill2 },
								{ calculator = myCC, colliderName = "wall", 
								  bodyType = "static", bounce = 1, friction = 0 } )

	local tw = newRect( layers.content, centerX, top,
								{ w = fullw, h = 40, anchorY = 0, 
								  fill = common.backFill2 },
								{ calculator = myCC, colliderName = "wall", 
								  bodyType = "static", bounce = 1, friction = 0 } )


	local bw = newRect( layers.content, centerX, bottom,
								{ w = fullw, h = 40, anchorY = 1, 
								  fill = common.backFill2 },
								{ calculator = myCC, colliderName = "wall", 
								  bodyType = "static", bounce = 1, friction = 0 } )

	--
	-- Game label
	--
	local gameLabel = easyIFC:quickLabel( layers.interfaces, "001 UniPong", bw.x, bw.y - 20, ssk.gameFont(), 20 )


	--
	-- Create the paddle
	--
	local function onEnterFrame( self )
		if( self.isMoving and self.targetY ) then
			local dy = self.targetY - self.y
			if( mAbs( dy ) <= common.paddleSnapDist ) then
				self.y = self.targetY
				self:setLinearVelocity(0,0)
			
			elseif( self.y > self.targetY ) then
				self:setLinearVelocity( 0, -common.paddleSpeed )
			
			elseif( self.y < self.targetY ) then
				self:setLinearVelocity( 0, common.paddleSpeed )
			end
		else
			self:setLinearVelocity(0,0)
		end
	end

	local function onFinalize( self )
		ignoreList( { "enterFrame", "onOneTouch" }, self )
	end

	local paddle = newRect( layers.content, right - 80, centerY, 
		                     { w = 20, h = 80,		                     	
		                       enterFrame = onEnterFrame, 
		                       finalize = onFinalize },
		                     { calculator = myCC, colliderName = "paddle", 
								  bodyType = "kinematic", bounce = 1, friction = 0 } )

	function paddle.onOneTouch( self, event )
		self.isMoving = (event.phase ~= "ended")
		self.targetY = event.y
		self.targetY = ( self.targetY < common.paddleMinY ) and common.paddleMinY or self.targetY
		self.targetY = ( self.targetY > common.paddleMaxY ) and common.paddleMaxY or self.targetY

	end; listen( "onOneTouch", paddle )

	
	local function onCollision( self, event )

		--
		-- Increment score if this collision is with paddle
		--
		if( event.phase == "began" and event.other.colliderName == "paddle" ) then
			-- SSK2 PRO users have sound manager		
			post( "onSound", { sound = "bounce" } )
			common.score = common.score + 1

		--
		-- Just bounce and play a sound if this is a wall
		--
		elseif( event.phase == "began" and event.other.colliderName == "wall" ) then
			-- SSK2 PRO users have sound manager		
			post( "onSound", { sound = "bounce" } )

		--
		-- Die if we hit the trigger
		--
		elseif( event.phase == "began" and event.other.colliderName == "trigger" ) then
			post( "onDied" )

		end
		return false
	end


	local ball = newImageRect( layers.content, left + 100, centerY, 
		                        "images/misc/circle.png",
									{ size = 34, collision = onCollision, 
									  fill = common.yellow },
									{ radius = 16, calculator = myCC, colliderName = "ball", 
								  		bounce = 1, friction = 0 } )

	-- Fixed list of possible starting angles to control starting velocity.
	--
	-- This is better than random range because we want to avoid
	-- a horizontal or near horizontal starting velocity
	local angleDeltas = { -45, -30, -20, -15, -10, 10, 15, 20, 30, 45 }
	function ball.onOneTouch( self, event )
		ignore("onOneTouch", self)
		local launchAngle = 90 + angleDeltas[mRand(1,#angleDeltas)]
		local vec = angle2Vector( launchAngle, true )
		vec = scaleVec( vec, common.ballSpeed )
		ball:setLinearVelocity( vec.x, vec.y )
	end; listen( "onOneTouch", ball )


	--
	-- If the ball hits this, we die.
	--
	local trigger = newRect( layers.content, right, centerY, 
									{ w = 40, h = fullh - 80, fill = common.red, 
									  alpha = 0.2, anchorX = 1 },
									{ calculator = myCC, colliderName = "trigger", 
										isSensor = true } )

end


return game



