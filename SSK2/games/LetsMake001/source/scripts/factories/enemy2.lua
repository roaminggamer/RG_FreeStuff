-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- enemy Factory
-- =============================================================
local common 	= require "scripts.common"
local myCC 		= require "scripts.myCC"
local physics 	= require "physics"
local trails 	= require "scripts.bulletTrails"

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mFloor				= math.floor
local mAbs 					= math.abs
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

local movep = ssk.actions.movep

-- =============================================================
-- Locals
-- =============================================================
local initialized = false

-- =============================================================
-- Forward Declarations
-- =============================================================

-- =============================================================
-- Factory Module Begins
-- =============================================================
local factory = {}

-- ==
--    init() - One-time initialization only.
-- ==
function factory.init( params )
	if(initialized) then return end
	initialized = true
end

-- ==
--    reset() - Reset any per-game logic/settings.
-- ==
function factory.reset( params )
end

-- ==
--    new() - Create new instance(s) of this factory's object(s).
-- ==
function factory.new( group, x, y, params )
	params = params or { }

	local target = { x = x, y = y }

	-- Create enemy with a foot
	local enemy = newImageRect( group, x, y, "images/edragonb1.png",
		{ 	size = common.enemySize, alpha = 1, rotation = 90, 
		   turnDir = 1, frame = 1, frameDir = 1 }, 
		{	isFixedRotation = false, isSensor = true, 
			calculator = myCC, colliderName = "enemy", radius = common.enemySize/2 - 2 } )

	--
	-- Track enemy's initial x-position
	--
	enemy.x0 = enemy.x	

	--
	-- Add 'enterFrame' listener to enemy to:
	--
	-- 1. Dampen vertical velocity, using actions library.
	-- 2. Maintain forward velocity.
	-- 3. Count distance progress.
	--
	local changeCount = 0
	local lastFrameTime = getTimer()
	enemy.enterFrame = function( self )
		if( common.isGameRunning == false ) then return end

		local curTime = getTimer()
		local dt = curTime - lastFrameTime
		if( dt >= common.enemyAnimTime ) then
			lastFrameTime = curTime
			self.frame = self.frame + self.frameDir
			if( self.frame > 4 ) then
				self.frame = 3
				self.frameDir = -1
			elseif( self.frame < 1 ) then
				self.frame = 2
				self.frameDir = 1
			end
			self.fill = { type = "image", filename = "images/edragonb" .. self.frame .. ".png" }

			-- Change course every 30 flaps
			if(changeCount > 30 ) then
				changeCount = 0
				local x = (common.cellSize * (common.cols-3))/2
				x = centerX + mRand( -x, x )
				local y = (common.cellSize * (common.rows-3))/2 
				y = centerY + mRand( -y, y ) + common.cellSize/2
				params.target.x = x
				params.target.y = y
			end
			changeCount = changeCount + 1

		end
		

		ssk.actions.face( self, 
			{ 
				pause = false,
				target = params.target,
				rate = common.enemyTurnRate
			} )
		ssk.actions.movep.forward( self, { rate = common.enemySpeed } )	

	end; listen("enterFrame",enemy)


	--
	-- Add Collision Listener 
	--
	enemy.collision = function( self, event )
		--
		-- Ignore all phases except 'began'
		--
		if( event.phase ~= "began" ) then return false end

		--
		-- Localize other to make typing easier/faster
		--
		local other = event.other

		if( other.colliderName == "pbullet" ) then			
			local factoryMgr 	= require "scripts.factories.factoryMgr"
			local x,y,parent = self.x, self.y, self.parent
			nextFrame(function() factoryMgr.new( "coin", parent, x, y )	end )

			-- Different responses for different bullet types
			if( other.myType == 1 or other.myType == 3 ) then
				ignoreList( { "enterFrame" }, self )
				common.enemies[self] = nil
				display.remove( self )
				post( "onSound", { sound = "gate"} )

			else
				transition.to( self, { time = common.poisonTime, alpha = 0.5, 
					onComplete =
						function()
							if( common.isGameRunning == false) then return end
							ignoreList( { "enterFrame" }, self )
							common.enemies[self] = nil
							display.remove(self) 
							post( "onSound", { sound = "gate"} )
						end } )
			end

		end

		return false
	end; enemy:addEventListener( "collision" )

	--
	-- Attach a finalize event to the enemy so it cleans it self up
	-- when removed.
	--	
	enemy.finalize = function( self )
		common.enemies[self] = nil
		ignoreList( { "enterFrame" }, self )
	end; enemy:addEventListener( "finalize" )

	enemy:setLinearVelocity( common.enemyVelocity, 0 )	

	common.enemies[enemy] = enemy

	return enemy
end

return factory