-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Player Factory
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

	-- Create player with a foot
	local player = newImageRect( group, x, y, "images/dragon1.png",
		{ 	size = common.playerSize, alpha = 1, rotation = 90, 
		   turnDir = 1, firing = false, frame = 1, frameDir = 1 }, 
		{	isFixedRotation = false,  
			calculator = myCC, colliderName = "player", radius = common.playerSize/2 - 2 } )
	
	--
	-- Track player's initial x-position
	--
	player.x0 = player.x	

	--
	-- Add 'enterFrame' listener to player to:
	--
	-- 1. Dampen vertical velocity, using actions library.
	-- 2. Maintain forward velocity.
	-- 3. Count distance progress.
	--
	local lastFrameTime = getTimer()
	player.enterFrame = function( self )
		if( common.isGameRunning == false ) then return end

		local curTime = getTimer()

		-- See if we need to change the 'dragon fill' (manual animation technique)
		--
		local dt = curTime - lastFrameTime		
		if( dt >= common.playerAnimTime ) then
			lastFrameTime = curTime
			self.frame = self.frame + self.frameDir
			if( self.frame > 4 ) then
				self.frame = 3
				self.frameDir = -1
			elseif( self.frame < 1 ) then
				self.frame = 2
				self.frameDir = 1
			end
			self.fill = { type = "image", filename = "images/dragon" .. self.frame .. ".png" }
		end

		-- Turn and move with action.* library:
		-- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/actions1/#actions-library-sskactions-part1
		local toAngle = (self.turnDir<0) and (self.rotation - 90) or (self.rotation + 90)
		ssk.actions.face( self, 
			{ 
				angle = toAngle,
				rate = common.playerTurnRate * mAbs(self.turnDir)
			} )
		ssk.actions.movep.forward( self, { rate = common.playerSpeed } )	


		if( self.firing ) then 
			self:fire()
		end

	end; listen("enterFrame",player)

	--
	-- Add Two Touch Listeners
	--
	-- To Turn
	player.onTwoTouchLeft = function( self, event )
		if( event.phase == "began" ) then 
			transition.cancel( self )
			transition.to( self, { turnDir = -1, time = common.playerDirectionTime, 
				                    transition = common.playerDirectionEasing } )
			--self.turnDir = -1
		elseif( event.phase == "ended" ) then 
			transition.cancel( self )
			transition.to( self, { turnDir = 1, time = common.playerDirectionTime, 
				                    transition = common.playerDirectionEasing } )
			--self.turnDir = 1
		end
		return true
	end; listen( "onTwoTouchLeft", player )
	
	-- To Fire
	player.onTwoTouchRight = function( self, event )
		if( event.phase == "began" ) then 
			self.firing = true
		elseif( event.phase == "ended" ) then 
			self.firing = false
		end
		return true
	end 
	listen( "onTwoTouchRight", player )

	player.key = function( self, event )
		table.dump(event)
		if( event.keyName == "buttonA" or
			 event.keyName == "space" ) then
			if( event.phase == "down") then 
				self.firing = true
			elseif( event.phase == "up" ) then 
				self.firing = false
			end
		end
		return false
	end 
	listen( "key", player )

	--
	-- Player 'Firing' Function
	--
	local lastFireTime = 0
	player.fire = function( self )
		local curTime = getTimer()
		local dt = curTime - lastFireTime
		if( dt < common.playerFirePeriod ) then return end
		lastFireTime = curTime

		-- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/math2D/
		local vec = ssk.math2d.angle2Vector( self.rotation, true )
		vec = ssk.math2d.scale( vec, player.size/2 )
		local bullet = newCircle( self.parent, self.x + vec.x, self.y + vec.y, 
										  { size = self.contentWidth/8 },
										  { calculator = myCC, colliderName = "pbullet" } )

		local vec = ssk.math2d.angle2Vector( self.rotation + mRand( -5, 5 ), true )
		vec = ssk.math2d.scale( vec, common.playerBulletSpeed )

		bullet:setLinearVelocity( vec.x, vec.y )
		transition.to( bullet, 
			{ alpha = 0, delay = common.playerBulletLife, 
			  time = 0, onComplete = display.remove } )

		bullet.myType = common.bulletType
		bullet:setFillColor( unpack( common.bulletColors[common.bulletType] ) )
		trails.addTrail( bullet, 1, nil, common.bulletTrailColors[common.bulletType] )

		-- Add lightning code for lightning bullets 
		if( common.bulletType == 3 ) then
			local trailFunc = bullet.enterFrame
				bullet.enterFrame = function( self )
					for k,v in pairs(common.enemies) do

						if( display.isValid(v) and display.isValid(self) and
						    ssk.math2d.isWithinDistance( self, v, common.lightningDistance ) ) then


							post( "onSound", { sound = "gate"} )

						   local zap = display.newLine( self.parent, self.x, self.y, v.x, v.y )
						   zap.strokeWidth = 2
						   transition.to( zap, { alpha = 0, time = 200, onComplete = display.remove })

							local factoryMgr 	= require "scripts.factories.factoryMgr"
							factoryMgr.new( "coin", v.parent, v.x, v.y )

							-- Different responses for different bullet types
							ignoreList( { "enterFrame" }, v )
							common.enemies[v] = nil
							display.remove( v )
							
						end

					end
					trailFunc( self )
				end
			end

	end

	--
	-- Add Collision Listener 
	--
	player.collision = function( self, event )
		--
		-- Ignore all phases except 'began'
		--
		if( event.phase ~= "began" ) then return false end

		--
		-- Localize other to make typing easier/faster
		--
		local other = event.other

		--
		-- If it is a gem,
		--
		-- 1. Remove the coin.
		-- 2. Add 1 to our coin count
		-- 3. Dipatch a sound event to play coin sound (if it was set up)
		--
		if( other.colliderName == "gem" ) then			
			common.bulletType = other.gemType
			post("onGem", { gemType = other.gemType } )
			post("onSound", { sound = "gate" } )
			display.remove( other )
		end


		--
		-- If it is a coin,
		--
		-- 1. Remove the coin.
		-- 2. Add 1 to our coin count
		-- 3. Dipatch a sound event to play coin sound (if it was set up)
		--
		if( other.colliderName == "coin" ) then
			display.remove( other )
			common.coins = common.coins + 1
			post("onSound", { sound = "coin" } )
		end

		--
		-- If it is a wall or enemy,
		--
		-- 1. Destroy the player.
		-- 2. Dipatch a sound event to play coin sound (if it was set up)
		-- 3. Dispatch a 'player died' event.
		--
		if( other.colliderName == "wall" or other.colliderName == "enemy" ) then
			display.remove( self )
			post("onDied" )
			post("onSound", { sound = "died" } )
		end

		return false
	end; player:addEventListener( "collision" )

	--
	-- Attach a finalize event to the player so it cleans it self up
	-- when removed.
	--	
	player.finalize = function( self )
		ignoreList( { "onTwoTouchRight", "onTwoTouchLeft", "key", "enterFrame" }, self )
	end; player:addEventListener( "finalize" )

	player:setLinearVelocity( common.playerVelocity, 0 )	

	return player
end

return factory