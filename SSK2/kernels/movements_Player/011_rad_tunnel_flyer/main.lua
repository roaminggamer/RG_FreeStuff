-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (44/217)
-- =============================================================
-- Kernel: Fundamental movement from RAD1 (a game I published a long time ago)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            gameFont 				= "Prime.ttf",
	            debugLevel 				= 0 } )
-- =============================================================
-- KERNEL CODE BEGINS BELOW
-- =============================================================

-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local mRand          = math.random
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

local debugEn			= true

local playerDir			= 1
local playerSize 		= 40
local gapSize 			= playerSize * 2
local wallSize 			= 50

local lastY
local tweenY 			= 200
local gapSide 			= 0

local difficulty 		= 1

local diffMult 			= 1
local diffMult2 		= 1
local diffMult3 		= 1
local diffMult4			= 1


local rotRate_initial 	= 150
local vBase_initial 	= 120 * 2
local vDelta_initial 	= 150 * 2
local vIncr_initial 	= 50 * 2
local vIncr2_initial 	= 150 * 2

local leftThrust 		= false
local rightThrust 		= false

local rotRate 			= rotRate_initial
local vBase 			= vBase_initial
local vDelta 			= vDelta_initial
local vIncr 			= vIncr_initial
local vIncr2 			= vIncr2_initial
local vMax 				= vBase
local vCur 				= vBase

local function setDifficulty( newDiff )
	difficulty = newDiff	
	diffMult 			= (1 + (difficulty-1)/20 )
	diffMult2 			= (1 + (difficulty-1)/10 )
	diffMult3 			= (1 + (difficulty-1)/5 )
	diffMult4 			= (1 + (difficulty-1)/30 )
	rotRate 			= rotRate_initial * diffMult2
	vBase 				= vBase_initial * diffMult
	vDelta 				= vDelta_initial * diffMult
	vIncr 				= vIncr_initial * diffMult3
	vIncr2 				= vIncr2_initial * diffMult4
	vMax 				= vBase
	vCur 				= vBase

	-- Caps
	if( rotRate > 360 ) then
		rotRate = 360 
	end

	-- Report
	if( debugEn ) then
		print("difficulty == " .. tostring( difficulty ) )
		print("     vBase == " .. tostring( vBase ) )
		print("    vDelta == " .. tostring( vDelta ) )
		print("     vIncr == " .. tostring( vIncr ) )
		print("    vIncr2 == " .. tostring( vIncr2 ) )
		print("      vMax == " .. tostring( vMax ) )
		print("   rotRate == " .. tostring( rotRate ) )
	end
end
setDifficulty(1)

--
-- Setup physics
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")

--
-- Be lazy and use RG Collision calculator
local myCC = ssk.cc:newCalculator()
myCC:addNames( "player", "trigger", "wall" )
myCC:collidesWith( "player", { "trigger", "wall" } )

local layers = quickLayers( nil, "background", "world", { "content" } )

local createSegment


local function createPlayer( x, y )

	-- Create player with a foot
	local player = newImageRect( layers.content, x, y, "images/arrow.png", 
		{ size = playerSize, jumpImpulse = 12, isMoving = false,
		  dA = 0 }, 
		{ radius = playerSize/2, bounce = 0,  friction = 0, 
		  calculator = myCC, colliderName = "player",
		  gravityScale = 0.0, linearDamping = 1, density = 1  } )


	--player:setLinearVelocity( 0, -500 )

	function player.collision( self, event ) 
		local isWall = (event.other.colliderName == "wall")
		local isPlatform = (event.other.colliderName == "platform")

		if( event.phase == "began" ) then
			if( isWall ) then 
				-- Die?
			end
		elseif( event.phase == "ended" ) then
		end		
	end
	player:addEventListener( "collision" )


	-- Two-touch handlers
	player.onTwoTouchLeft = function( self, event )
		if( isDestroyed == true or isRunning == false ) then ignore( "onTwoTouchLeft", self ); return; end
		if(event.phase == "began") then 
			self.dA = self.dA - rotRate
			if( self.dA < -rotRate ) then 
				self.dA = -rotRate
			end
			leftThrust = true
			self.leftInputActive = true

		elseif(event.phase == "ended") then 
			if( not self.leftInputActive ) then return true end
			self.leftInputActive = false
			self.dA = self.dA + rotRate
			if( self.dA > rotRate ) then 
				self.dA = rotRate
			end
			leftThrust = false
		end
		return true
	end
	listen( "onTwoTouchLeft", player )

	player.onTwoTouchRight = function( self, event )
		if( isDestroyed == true or isRunning == false ) then ignore( "onTwoTouchRight", self ); return; end
		if(event.phase == "began") then 
			self.dA = self.dA + rotRate
			if( self.dA > rotRate ) then 
				self.dA = rotRate
			end
			rightThrust = true
			self.rightInputActive = true

		elseif(event.phase == "ended") then 
			if( not self.rightInputActive ) then return true end
			self.rightInputActive = false
			self.dA = self.dA - rotRate
			if( self.dA < -rotRate ) then 
				self.dA = -rotRate
			end
			rightThrust = false
		end
		return true
	end
	listen( "onTwoTouchRight", player )

	-- enterFrame code to handler turning and trail drawing calls
	--
	player.lastFrameTime = getTimer()
	player.enterFrame = function( self, event )		
		if( isDestroyed == true or isRunning == false ) then ignore( "enterFrame", self ); return; end
		local curTime = getTimer()		
		local dt = (curTime - self.lastFrameTime)/1000
		self.lastFrameTime = curTime

		-- Turn
		local dA = self.dA * dt
		if(dA ~= 0) then
			self.rotation = self.rotation + dA
			if(self.rotation < 0) then self.rotation = self.rotation + 360 end
		end

		-- Adjust vMax
		vMax = vBase
		if(leftThrust) then vMax = vMax + vDelta end
		if(rightThrust) then vMax = vMax + vDelta end

		-- Get Current Velocity
		local vx,vy = self:getLinearVelocity()
		local mag = lenVec( vx, vy )

		-- Adjust vCur
		if(vCur < vMax ) then
			vCur = vCur + vIncr * dt
		elseif(vCur > vMax ) then
			vCur = vCur - vIncr2 * dt
		end

		-- Move
		local vec = angle2Vector( self.rotation, true )
		vec = scaleVec( vec, vCur )
		self:setLinearVelocity( vec.x, vec.y )

		--self:drawTrail()
	end
	listen( "enterFrame", player )

	ssk.camera.tracking( player, layers.world, { lockX = true } )		
end


local function onCollision( self, event )
	if( event.phase == "began" ) then
		self:removeEventListener("collision")
		if( self.isTriggered ) then return true end
		self.isTriggered = true
		self:setFillColor(unpack(_C_))
		nextFrame( function() createSegment( self.x, nil, false ) end )
	end
	return true
end

createSegment = function( x, y, preTrigger )
	y = y or lastY - tweenY
	lastY = y

	local leftWall = newRect( layers.content, left, y,
		{ w =  wallSize, h = tweenY-4, fill = _O_, alpha = 0.25, anchorX = 0, anchorY = 1 }, 
		{ bodyType = "kinematic", bounce = 0,  friction = 0, 
		  calculator = myCC, colliderName = "wall" } )

	local rightWall = newRect( layers.content, right, y,
		{ w =  wallSize, h = tweenY-4, fill = _O_, alpha = 0.25, anchorX = 1, anchorY = 1 }, 
		{ bodyType = "kinematic", bounce = 0,  friction = 0, 
		  calculator = myCC, colliderName = "wall" } )


	local trigger = newRect( layers.content, centerX, y,
		{ w = fullw-4, h = tweenY-4, fill = _Y_, alpha = 0.05, anchorY = 1, 
		  stroke = _Y_, isTriggered = preTrigger, collision = onCollision }, 
		{ bodyType = "static", bounce = 0,  friction = 0, 
		  calculator = myCC, colliderName = "trigger", isSensor = true } )

	if( trigger.isTriggered == true ) then
		trigger:setFillColor(unpack(_C_))
		trigger:removeEventListener("collision")
	end

end

createSegment( centerX, bottom + 80, true )
createSegment( centerX, nil, true )
createSegment( centerX, nil, true )
createSegment( centerX, nil, true )
createSegment( centerX, nil, true )
createSegment( centerX, nil, false )
createSegment( centerX, nil, false )
createSegment( centerX, nil, false )
createSegment( centerX, nil, false )
createSegment( centerX, nil, false )
createPlayer( centerX, centerY )

ssk.easyInputs.twoTouch.create( layers.background, { debugEn = false, keyboardEn = true } )

