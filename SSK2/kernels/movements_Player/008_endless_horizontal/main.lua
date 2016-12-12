-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (35/114)
-- =============================================================
-- Kernel: Endless Tunnel (Jet Pack Joyride-ish)
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
-- Useful Localizations
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local mRand				= math.random
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
-- Setup physics
local physics = require "physics"
physics.start()
physics.setGravity(0,20)
--physics.setDrawMode("hybrid")

--
-- Be lazy and use RG Collision calculator
local myCC = ssk.cc:newCalculator()
myCC:addNames( "player", "foot", "platform", "trigger" )
myCC:collidesWith( "player", { "platform", "trigger" } )
myCC:collidesWith( "foot", { "platform" } )

local layers = quickLayers( nil, "background", "world", { "content" } )

local createHallSegment


local function createPlayer( x, y )

	-- Create player with a foot
	local player = newRect( layers.content, x, y,
		{ w = 40, h = 40, fill = _CYAN_, alpha = 0.25, jumpImpulse = 13 }, 
		{ bounce = 0, friction = 0, calculator = myCC, colliderName = "player", isFixedRotation = true } )
	player.moveX = 0
	player.moveY = 0
	player.inAir = false

	--[[
	player.foot = newRect( layers.content, player.x, player.y + 20,
		{ w = 40, h = 30, fill = _Y_, alpha = 0.1, myOwner = player },
		{ calculator = myCC, colliderName = "foot", gravityScale = 0, 
		  isSensor = true, isFixedRotation = true } )

	-- Add foot methods to handle tracking player and detecting collisions.
	function player.foot.enterFrame( self ) 
		self.x = player.x
		self.y = player.y + 20
	end; listen( "enterFrame", player.foot )

	-- 
	function player.foot.collision( self, event ) 
		local isPlatform 	= (event.other.colliderName == "platform")

		if( event.phase == "began" ) then
			self.myOwner.inAir = false
		
		elseif( event.phase == "ended" ) then
			self.myOwner.inAir = true
			self.myOwner.justJumped = false
		end		
	end
	player.foot:addEventListener( "collision" )
	--]]

	player.enterFrame = function( self )
		local vx,vy = player:getLinearVelocity( )
		player:setLinearVelocity( 500, vy )
		local vx,vy = player:getLinearVelocity( )
		print( round(vx), self.x )
		if( self.thrust ) then
			--print(self.thrust)
			self:applyForce( 0, -self.thrust * self.mass, self.x, self.y  )
		end
	end; listen("enterFrame",player)

	player.touch = function( self, event )
		print(event.phase)
		if( event.phase == "began" ) then 
			self.thrust = 60
		elseif( event.phase == "ended" ) then
			self.thrust = 0		
		end

		return true
	end
	Runtime:addEventListener("touch", player)

	ssk.camera.tracking( player, layers.world, { lockY = true } )		

	player:setLinearVelocity( 500, 0 )
end
	


local function onCollision( self, event )
	if( event.phase == "began" ) then
		--self:removeEventListener("collision")
		if( self.isTriggered ) then return true end
		self.isTriggered = true
		self:setFillColor(unpack(_C_))
		nextFrame( function() createHallSegment( nil, self.y, false ) end )
	end
	return true
end

local lastX
local tweenX = fullw/2
local count = 1
createHallSegment = function( x, y, preTrigger )
	x = x or lastX + tweenX
	lastX = x
	print( count )
	count = count + 1
	local ceiling = newRect( layers.content, x, top,
		{ w = tweenX, h = 40, fill = _G_, alpha = 0.25, anchorY = 0, }, 
		{ bodyType = "static", bounce = 0, friction = 0, calculator = myCC, colliderName = "platform" } )

	local ceiling = newRect( layers.content, x, bottom,
		{ w = tweenX, h = 40, fill = _G_, alpha = 0.25, anchorY = 1, }, 
		{ bodyType = "static", bounce = 0, friction = 0, calculator = myCC, colliderName = "platform" } )

	local trigger = newRect( layers.content, x, centerY,
		{ w = tweenX, h = fullh, fill = _Y_, alpha = 0.05, stroke = _Y_, 
		  collision = onCollision, isTriggered = preTrigger }, 
		{ bodyType = "static", bounce = 0, friction = 0, 
		  calculator = myCC, colliderName = "trigger", isSensor = true } )

	if( trigger.isTriggered == true ) then
		trigger:setFillColor(unpack(_C_))
		trigger:removeEventListener("collision")
	end

end

createHallSegment( left, centerY, true )
createHallSegment( nil, centerY, true )
createHallSegment( nil, centerY, false )
createPlayer( centerX, centerY )
