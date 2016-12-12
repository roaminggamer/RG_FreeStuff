-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (37/17
-- =============================================================
-- Kernel: Endless Jumper
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
physics.setGravity(0,10)
--physics.setDrawMode("hybrid")

--
-- Set up collision calculator
local myCC = ssk.cc:newCalculator()
myCC:addNames( "player", "foot", "platform", "trigger" )
myCC:collidesWith( "player", { "platform", "trigger" } )
myCC:collidesWith( "foot", { "platform" } )

local layers = quickLayers( nil, "background", "world", { "content" } )

local createPlatform


local function createPlayer( x, y )

	-- Create player with a foot
	local player = newRect( layers.content, x, y,
		{ w = 40, h = 40, fill = _CYAN_, alpha = 0.25, jumpImpulse = 13 }, 
		{ bounce = 0, friction = 0, calculator = myCC, colliderName = "player", isFixedRotation = true } )
	player.moveX = 0
	player.moveY = 0
	player.inAir = false

	player.foot = newRect( layers.content, player.x, player.y + 20,
		{ w = 40, h = 30, fill = _Y_, alpha = 0.1, myOwner = player },
		{ calculator = myCC, colliderName = "foot", gravityScale = 0, 
		  isSensor = true, isFixedRotation = true } )


	-- 
	-- Add foot methods to handle tracking player and detecting collisions.
	function player.foot.enterFrame( self ) 
		self.x = player.x
		self.y = player.y + 20
	end; listen( "enterFrame", player.foot )

	function player.foot.collision( self, event ) 
		local isPlatform 	= (event.other.colliderName == "platform")

		if( event.phase == "began" ) then
			self.myOwner.inAir = false
		
		elseif( event.phase == "ended" ) then
			self.myOwner.inAir = true
			if( not self.myOwner.justJumped ) then
				local vx,vy = self.myOwner:getLinearVelocity()
				vx = vx/5
				self.myOwner:setLinearVelocity( vx, vy )
			end
			self.myOwner.justJumped = false
		end		
	end
	player.foot:addEventListener( "collision" )


	--
	-- Add methods to player to handle: one-way platform and jumping
	--
	-- Tip: This is the ONLY important part of the demo.  See how we detect a 
	--      pre-collision from the bottom and then disable the contact this time ONLY?
	--
	player.preCollision = function( self, event )
		local contact 		= event.contact
		local other 		= event.other
		local dy 			= self.y - other.y
		local deltaError 	= 1
		local delta 		= self.contentHeight/2 + other.contentHeight/2 - deltaError
		
		if( other.isPlatform ) then
			if( contact.isEnabled and dy > -delta ) then
				contact.isEnabled = false
			end
		end

	end
	player:addEventListener( "preCollision" )


	player.touch = function( self, event )
		if( event.phase ~= "began" ) then return false end
		if( self.inAir ) then return end
		self:applyLinearImpulse( 0, -self.jumpImpulse * self.mass, self.x, self.y )
		self.inAir = true
		self.justJumped = true
		return true
	end
	Runtime:addEventListener("touch", player)


	ssk.camera.tracking( player, layers.world, params )		
end


local function onCollision( self, event )
	if( event.phase == "began" ) then
		self:removeEventListener("collision")
		if( self.isTriggered ) then return true end
		self.isTriggered = true
		self:setFillColor(unpack(_C_))
		nextFrame( function() createPlatform( self.x, nil, false ) end )
	end
	return true
end

local lastY
local tweenY = 200
createPlatform = function( x, y, preTrigger )
	print(x,y,preTrigger)
	y = y or lastY - tweenY
	lastY = y
	local plat = newRect( layers.content, x, y,
		{ w = 160, h = 40, fill = _G_, alpha = 0.25 }, 
		{ bodyType = "static", bounce = 0, friction = 0, calculator = myCC, colliderName = "platform" } )
	plat.isPlatform = true

	local trigger = newRect( layers.content, centerX, y,
		{ w = fullw-4, h = tweenY-4, fill = _Y_, alpha = 0.05, anchorY = 1, stroke = _Y_, isTriggered = preTrigger,
		  collision = onCollision }, 
		{ bodyType = "static", bounce = 0, friction = 0, calculator = myCC, colliderName = "trigger", isSensor = true } )

	if( trigger.isTriggered == true ) then
		trigger:setFillColor(unpack(_C_))
		trigger:removeEventListener("collision")
	end

end

createPlatform( centerX, centerY + 80, true )
createPlatform( centerX, nil, false )
createPlatform( centerX, nil, false )
createPlayer( centerX, centerY )
