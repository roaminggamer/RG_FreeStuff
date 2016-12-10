-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

--[[
		This example shows how to use the catmull-spline algorithm to convert a 'rough' path into a smoothed path.		
--]]

--
-- 1. Require the camera module
local camera = require "camera"

--
-- 2. Create display groups to use in camera code.
local world = display.newGroup()
local back = display.newGroup()
local content = display.newGroup()
world:insert( back )
world:insert( content )


--
-- 3. Add background image and scale it up a bit
local background = display.newImageRect( back, "colored_castle.png", 1024, 1024 )
local scale = 1.5 * 1024/display.actualContentWidth
background:scale(scale,scale)
background.x = display.contentCenterX
background.y = display.contentCenterY

--
-- 4. Create an object to be 'tracked'
local player = display.newImageRect( back, "yellow_round.png", 60, 60 )
player.x = display.contentCenterX 
player.y = display.contentCenterY

--
-- 5. A simple function to move 'tracked' object around randomly
local function autoMover( self )
	local speed = 250
	local toX = display.contentCenterX + math.random( -display.contentWidth/2 + 50, display.contentWidth/2 - 50 )
	local toY = display.contentCenterX + math.random( -display.contentHeight/2 + 50, display.contentHeight/2 - 50 )

	local dx = toX - self.x
	local dy = toY - self.y

	local dist = (dx * dx) + (dy * dy)
	dist = math.sqrt(dist)

	local time = 1000 * dist/speed

	self.mx = self.x
	self.my = self.y

	transition.to( self, { mx = toX, my = toY, time = time, onComplete = autoMover } )
end
autoMover( player )

-- 
-- 6. Use 'enterFrame' listener to do actual movement of object otherwise camera will be jerky
-- This is a side-effect of transitions.  If we were moving with phyics we wouldn't need this
-- extra code.
local function onEnterFrame( self )
	-- 
	-- Abort early if the object is not valid any more
	if( self.removeSelf == nil ) then
		Runtime:removeEventListener( "enterFrame", self )
		return
	end

	-- 
	-- Move the player
	self.x = self.mx
	self.y = self.my
end

player.enterFrame = onEnterFrame
Runtime:addEventListener( "enterFrame", player )

--
-- 7. Attach camera to player and lock X-axis. (Must be after we start player's enterFrame listener)
camera.attach( player, world, true, false )	
