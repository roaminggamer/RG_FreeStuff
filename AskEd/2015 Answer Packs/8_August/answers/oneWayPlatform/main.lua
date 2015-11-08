-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted to create a one-way platform.", 
	"",
	"This shows how to do that."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- Load SSK
--require "ssk.loadSSK"

-- 
-- Useful Localizations
-- SSK
--
local newCircle 		= ssk.display.newCircle
local newRect 			= ssk.display.newRect
local newImageRect 		= ssk.display.newImageRect
local easyIFC   		= ssk.easyIFC
local isInBounds    	= ssk.easyIFC.isInBounds
local persist 			= ssk.persist
local isValid 			= display.isValid

local vector2Angle		= ssk.math2d.vector2Angle
local angle2Vector		= ssk.math2d.angle2Vector
local scaleVec			= ssk.math2d.scale

-- Corona & Lua
--
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

--
-- Setup physics
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
--physics.setDrawMode("hybrid")

--
-- Be lazy and use RG Collision calculator
local myCC = ssk.ccmgr:newCalculator()
myCC:addNames( "player", "foot", "platform", "ladder" )
myCC:collidesWith( "player", "platform", "ladder" )
myCC:collidesWith( "foot", "platform" )

--
-- Use RG Layers creator to organize our 'world'
local layers = ssk.display.quickLayers( nil, "underlay", "content", "overlay" )	


-- Create player with a foot
local player = newRect( layers.content, centerX, centerY + 260,
	{ w = 40, h = 40, fill = _CYAN_, alpha = 0.25, jumpImpulse = 13 }, 
	{ bounce = 0, friction = 0, calculator = myCC, colliderName = "player", isFixedRotation = true } )
player.moveX = 0
player.moveY = 0
player.inAir = false

player.foot = newRect( layers.content, player.x, player.y + 20,
	{ w = 40, h = 30, fill = _Y_, alpha = 0.1, myOwner = player },
	{ calculator = myCC, colliderName = "player", gravityScale = 0, 
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
	if( self.onLadder ) then return end
	if( self.inAir ) then return end
	self:applyLinearImpulse( 0, -self.jumpImpulse * self.mass, self.x, self.y )
	self.inAir = true
	self.justJumped = true
	return true
end
Runtime:addEventListener("touch", player)


-- 
-- Create some platforms
local plat = newRect( layers.content, centerX, centerY - 100,
	{ w = 160, h = 40, fill = _G_, alpha = 0.25 }, 
	{ bodyType = "static", bounce = 0, friction = 0, calculator = myCC, colliderName = "platform" } )
plat.isPlatform = true

local plat = newRect( layers.content, centerX, centerY + 100,
	{ w = 280, h = 40, fill = _G_, alpha = 0.25 }, 
	{ bodyType = "static", bounce = 0, friction = 0, calculator = myCC, colliderName = "platform" } )
plat.isPlatform = true

local plat = newRect( layers.content, centerX, centerY + 300,
	{ w = 400, h = 40, fill = _G_, alpha = 0.25 }, 
	{ bodyType = "static", bounce = 0, friction = 0, calculator = myCC, colliderName = "platform" } )
plat.isPlatform = true