-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016
-- =============================================================

-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs
local strMatch = string.match; local strGSub = string.gsub; local strSub = string.sub
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
--
-- Specialized SSK Features
local actions = ssk.actions
local rgColor = ssk.RGColor

ssk.misc.countLocals(1)

-- =============================================================
-- =============================================================
local twoTouch 		= ssk.easyInputs.twoTouch
-- Forward Declarations
local drawTrail

-- Locals
local player
local playerSize = 40

local example = {}
function example.stop()
	physics.pause()
	ignoreList( { "onTwoTouchLeft", "onTwoTouchRight", "enterFrame" }, player )
	timer.cancel( player.myTimer )
end

function example.run( group )
	--
	-- Start and Configure  physics
	local physics = require "physics"
	physics.start()
	physics.setGravity(0,0)
	--physics.setDrawMode("hybrid")

	-- create a 'wrapRect' as a proxy for wrapping calculations
	--
	local wrapRect = newRect( group, centerX, centerY, 
		                       { w = fullw + playerSize, h = fullh + playerSize,
		                         fill = { 0, 1, 1, 0.1}, stroke = {1,1,0,0.5}, strokeWidth = 1 } )


	-- Initialize 'input'
	--
	twoTouch.create( group, { debugEn = true, keyboardEn = true } )

	-- Create a 'arrow' as our player
	--
	player = newImageRect( group, centerX, centerY - 50, "images/arrow.png", { size = playerSize }, { radius = 20 } )

	-- Draw new 'trail' dot every 100 ms
	-- 
	player.timer = drawTrail
	player.myTimer = timer.performWithDelay( 100, player, -1 )

	-- Initialize fields on the player related to this movement style
	--
	player.dA = 0

	-- Set some general values associated with this movement
	--
	local common = {}
	common.diffMult 			= 1
	common.diffMult2 			= 1
	common.diffMult3 			= 1
	common.diffMult4			= 1
	common.rotRate_initial 	= 150
	common.vBase_initial 	= 120 * 2
	common.vDelta_initial 	= 150 * 2
	common.vIncr_initial 	= 50 * 2
	common.vIncr2_initial 	= 150 * 2
	common.leftThrust 		= false
	common.rightThrust 		= false
	common.rotRate 			= common.rotRate_initial
	common.vBase 				= common.vBase_initial
	common.vDelta 				= common.vDelta_initial
	common.vIncr 				= common.vIncr_initial
	common.vIncr2 				= common.vIncr2_initial
	common.vMax 				= common.vBase
	common.vCur 				= common.vBase	


	-- Two-touch handlers
	player.onTwoTouchLeft = function( self, event )
		if( isDestroyed == true or isRunning == false ) then ignore( "onTwoTouchLeft", self ); return; end
		if(event.phase == "began") then 
			self.dA = self.dA - common.rotRate
			if( self.dA < -common.rotRate ) then 
				self.dA = -common.rotRate
			end
			leftThrust = true
			self.leftInputActive = true

		elseif(event.phase == "ended") then 
			if( not self.leftInputActive ) then return true end
			self.leftInputActive = false
			self.dA = self.dA + common.rotRate
			if( self.dA > common.rotRate ) then 
				self.dA = common.rotRate
			end
			leftThrust = false
		end
		return true
	end
	listen( "onTwoTouchLeft", player )

	player.onTwoTouchRight = function( self, event )
		if( isDestroyed == true or isRunning == false ) then ignore( "onTwoTouchRight", self ); return; end
		if(event.phase == "began") then 
			self.dA = self.dA + common.rotRate
			if( self.dA > common.rotRate ) then 
				self.dA = common.rotRate
			end
			rightThrust = true
			self.rightInputActive = true

		elseif(event.phase == "ended") then 
			if( not self.rightInputActive ) then return true end
			self.rightInputActive = false
			self.dA = self.dA - common.rotRate
			if( self.dA < -common.rotRate ) then 
				self.dA = -common.rotRate
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
		else
			if( common.newRotRate ) then
				common.rotRate = common.newRotRate
				common.newRotRate = nil
			end
		end

		-- Adjust vMax
		common.vMax = common.vBase
		if(leftThrust) then common.vMax = common.vMax + common.vDelta end
		if(rightThrust) then common.vMax = common.vMax + common.vDelta end

		-- Get Current Velocity
		local vx,vy = self:getLinearVelocity()
		local mag = lenVec( vx, vy )

		-- Adjust vCur
		if(common.vCur < common.vMax ) then
			common.vCur = common.vCur + common.vIncr * dt
		elseif(common.vCur > common.vMax ) then
			common.vCur = common.vCur - common.vIncr2 * dt
		end

		-- Move
		local vec = angle2Vector( self.rotation, true )
		vec = scaleVec( vec, common.vCur )
		self:setLinearVelocity( vec.x, vec.y )

		actions.scene.rectWrap( self, wrapRect )		
	end
	listen( "enterFrame", player )

end

-- Helper function to draw a simple 'trail' of dots showing where the player has been
--
drawTrail = function( player )
	local dot = display.newCircle( player.parent, player.x, player.y, player.contentWidth/8 )
	dot:toBack()
	transition.to( dot, { alpha = 0, time = 750, onComplete = display.remove } )
end


return example
