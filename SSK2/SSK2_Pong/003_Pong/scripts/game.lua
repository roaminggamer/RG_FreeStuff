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
	common.score0 		= 0
	common.score1 		= 0
	common.gameMode 	= 0
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
		ignoreList( { "onGameOver" }, layers )
		display.remove( layers )
		layers = nil
	end

	-- Clear Score, Couins, Distance Counters
	common.score0 		= 0
	common.score1 		= 0
	common.gameMode 	= 0
end


-- ==
--    start() - Start game actually running.
-- ==
function game.start( group, params )
	params = params or { debugEn = false }

	game.destroy() 

	common.gameMode = params.gameMode or common.gameMode

	--
	-- Locals
	--
	local ball
	local allowMovement = false

	--
	-- Forward declaration
	--
	local doBallMoveCountdown

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
	--ssk.easyInputs.oneTouch.create(layers.underlay, { debugEn = params.debugEn, keyboardEn = true } )
	ssk.easyInputs.twoTouch.create(layers.underlay, { debugEn = params.debugEn, keyboardEn = true } )
	--ssk.easyInputs.oneStick.create( layers.underlay, { debugEn = true, joyParams = { doNorm = true } } )
	--ssk.easyInputs.twoStick.create( layers.underlay, { debugEn = true, joyParams = { doNorm = true } } )
	--ssk.easyInputs.oneStickOneTouch.create( layers.underlay, { debugEn = true, joyParams = { doNorm = true } } )


	--
	-- Create HUDs
	--
	factoryMgr.new( "scoreHUD", layers.interfaces, centerX - 80, top + 80, { scoreVariable = "score0" }  )
	factoryMgr.new( "scoreHUD", layers.interfaces, centerX + 80, top + 80, { scoreVariable = "score1" }  )
 
	--
	--
	-- Add player died listener to layers to allow it to do work if we need it
	function layers.onGameOver( self, event  )

		-- SSK2 PRO users have sound manager
		if( soundMgr ) then
			post( "onSound", { sound = "gameOver" } )
		end

		ignore( "onGameOver", self )
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

	end; listen( "onGameOver", layers )
	--post("onGameOver")


	-- 
	-- Draw Walls
	--

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
	local gameLabel = easyIFC:quickLabel( layers.interfaces, "003 Pong", bw.x, bw.y - 20, ssk.gameFont(), 20 )

	--
	-- Create the paddles
	--
	local function paddleEnterFrameMover( self )

		if( allowMovement and self.targetY ) then
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

	local function aiEnterFrameMover( self )
		
		if( allowMovement and isValid( ball ) ) then			

			--
			-- Only move if ball is moving toward this paddle and within half a screen
			--

			local vx, vy = ball:getLinearVelocity()
			if( self.paddleNum == 0 and vx > 0 ) then 
				self:setLinearVelocity(0,0)
				return 
			end
			if( self.paddleNum == 1 and vx < 0 ) then 
				self:setLinearVelocity(0,0)
				return 
			end
			local vec = ssk.math2d.sub( ball, self )
			if( ssk.math2d.length( vec ) > fullw/2 ) then 
				self:setLinearVelocity(0,0)
				return 
			end


			--
			-- Super Basic AI: Try to match ball Y position
			--
			local dy = ball.y - self.y
			if( mAbs( dy ) <= common.paddleSnapDist ) then
				self.y = ball.y
				self:setLinearVelocity(0,0)
			
			elseif( self.y > ball.y ) then
				self:setLinearVelocity( 0, -common.aiPaddleSpeed )
			
			elseif( self.y < ball.y ) then
				self:setLinearVelocity( 0, common.aiPaddleSpeed )
			end
		else
			self:setLinearVelocity(0,0)
		end

		-- Ensure paddle doesn't move too high or too low
		if( self.y < common.paddleMinY ) then
			self.y = common.paddleMinY
		elseif( self.y > common.paddleMaxY ) then
			self.y = common.paddleMaxY
		end
	end

	local function onTwoTouch( self, event )
		if( not allowMovement ) then return end

		-- Set paddle target for enterFrame mover
		self.targetY = event.y
		self.targetY = ( self.targetY < common.paddleMinY ) and common.paddleMinY or self.targetY
		self.targetY = ( self.targetY > common.paddleMaxY ) and common.paddleMaxY or self.targetY
	end	


	local function onFinalize( self )
		-- Ignore any listners in the list that are attached to the object.
		-- If a listener is not attached to the object it is skipped.
		--
		ignoreList( { "enterFrame", "onTwoTouchLeft", "onTwoTouchRight" }, self )
	end

	local leftPaddle = newRect( layers.content, left + 80, centerY, 
		                     { w = 20, h = 80, 
		                     	paddleNum = 0, -- 0 equals LEFT paddle
		                     	fill = (common.gameMode == 0 or common.gameMode == 1 ) and common.green or _W_,
		                       	finalize = onFinalize },
		                     { calculator = myCC, colliderName = "paddle", 
								  bodyType = "kinematic", bounce = 1, friction = 0 } )

	local rightPaddle = newRect( layers.content, right - 80, centerY, 
		                     { w = 20, h = 80, 
		                     	paddleNum = 1, -- 1 equals RIGHT paddle
		                     	fill = (common.gameMode == 0 ) and common.green or _W_,
		                       finalize = onFinalize },
		                     { calculator = myCC, colliderName = "paddle", 		
								  bodyType = "kinematic", bounce = 1, friction = 0 } )


	print("MODE????", common.gameMode )

	-- Mode 0: AI versus AI
	if( common.gameMode ==  0 ) then
		print("MODE0")
		leftPaddle.enterFrame = aiEnterFrameMover
		listen( "enterFrame", leftPaddle )

		rightPaddle.enterFrame = aiEnterFrameMover
		listen( "enterFrame", rightPaddle )


	-- Mode 1: One-player	
	-- AI (left) / Player (right)
	elseif( common.gameMode ==  1 ) then	
		print("MODE1")
		leftPaddle.enterFrame = aiEnterFrameMover
		listen( "enterFrame", leftPaddle )

		rightPaddle.enterFrame = paddleEnterFrameMover
		listen( "enterFrame", rightPaddle )

		rightPaddle.onTwoTouchRight = onTwoTouch
		listen( "onTwoTouchRight", rightPaddle )


	-- Mode 2: Two-player
	elseif( common.gameMode ==  2 ) then		
		print("MODE2")
		leftPaddle.enterFrame = paddleEnterFrameMover
		listen( "enterFrame", leftPaddle )

		rightPaddle.enterFrame = paddleEnterFrameMover
		listen( "enterFrame", rightPaddle )

		leftPaddle.onTwoTouchLeft = onTwoTouch
		listen( "onTwoTouchLeft", leftPaddle )

		rightPaddle.onTwoTouchRight = onTwoTouch
		listen( "onTwoTouchRight", rightPaddle )

	end


	
	local function onCollision( self, event )

		--
		-- Paddle bounce
		--
		if( event.phase == "began" and event.other.colliderName == "paddle" ) then
			-- SSK2 PRO users have sound manager		
			post( "onSound", { sound = "bounce" } )


		--
		-- Wall bounce
		--
		elseif( event.phase == "began" and event.other.colliderName == "wall" ) then
			-- SSK2 PRO users have sound manager		
			post( "onSound", { sound = "bounce" } )

		--
		-- Trigger Hit
		--
		elseif( event.phase == "began" and event.other.colliderName == "trigger" ) then
			ball.isVisible = false

			-- Stop allowing movement
			allowMovement = true
			
			if( event.other.side == 0 ) then
				common.score1 = common.score1 + 1
			else
				common.score0 = common.score0 + 1
			end

			-- Game ends if one player has maxScore
			if( common.score0 >= common.maxScore or common.score1 >= 10 ) then
				post( "onGameOver" )
				display.remove(ball)
			

			-- Start next round
			else
				-- SSK2 PRO users have sound manager		
				post( "onSound", { sound = "bounce" } )

				nextFrame( 
					function()
						ball.isVisible = true
						ball.x = centerX
						ball.y = centerY
						ball:setLinearVelocity( 0, 0)
					end )

				doBallMoveCountdown()
			end

		end
		return false
	end


	--
	-- Create the ball
	--
	ball = newImageRect( layers.content, centerX, centerY, 
		                        "images/misc/circle.png",
									{ size = 34, collision = onCollision, 
									  fill = common.yellow },
									{ radius = 16, calculator = myCC, colliderName = "ball", 
								  		bounce = 1, friction = 0 } )


	--
	-- If the ball hits this, the round is over.
	--
	local trigger = newRect( layers.content, left, centerY, 
									{ w = 40, h = fullh - 80, fill = common.red, 
									  alpha = 0.2, anchorX = 0, side = 0 },
									{ calculator = myCC, colliderName = "trigger", 
										isSensor = true } )


	local trigger = newRect( layers.content, right, centerY, 
									{ w = 40, h = fullh - 80, fill = common.red, 
									  alpha = 0.2, anchorX = 1, side = 1 },
									{ calculator = myCC, colliderName = "trigger", 
										isSensor = true } )

	

	doBallMoveCountdown = function()
		--
		-- Countdown To Start Label
		--
		local startLabel = easyIFC:quickLabel( layers.interfaces, "3", tw.x, tw.y + 20, ssk.gameFont(), 25 )
		startLabel.count = 3

		function startLabel.timer( self )
			if( not isValid( self ) ) then return end

			-- Update counter label
			self.count = self.count - 1
			self.text = self.count
			

			-- At zero?  Then start the game
			if( self.count == 0 ) then

				-- Go message
				self.text = "GO!"
				self.timer = display.remove
				timer.performWithDelay( 500, self )
				

				-- Start Ball Moving
				-- Fixed list of possible starting angles to control starting velocity.
				--
				-- This is better than random range because we want to avoid
				-- a horizontal or near horizontal starting velocity
				local angleDeltas = { -45, -30, -20, -15, -10, 10, 15, 20, 30, 45 }
				local launchAngle = 90 + angleDeltas[mRand(1,#angleDeltas)]
				local vec = angle2Vector( launchAngle, true )
				vec = scaleVec( vec, common.ballSpeed )
				ball:setLinearVelocity( vec.x, vec.y )
				allowMovement = true
			end

		end
		timer.performWithDelay( 1000, startLabel, 3 )
	end
	doBallMoveCountdown()




end


return game



