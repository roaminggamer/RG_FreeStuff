-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The asker wanted to replicate the movement of 'Sky Force'.", 
	"1. Tap the screen OR ",
	"2. Drag your finger around."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- 1. Require SSK or at a minimum the RG 2D Math lib
--require "ssk.loadSSK"
require "RGMath2D"


--
-- 2. Useful locals and localizations
local centerX 		= display.contentCenterX
local centerY 		= display.contentCenterY
local fullw 		= display.actualContentWidth
local fullh 		= display.actualContentHeight
local getTimer 		= system.getTimer

--
-- 3. Touch object (and our water)
local touchObj = display.newRect( centerX, centerY + 100, 1000, 600  )

-- Following is trick to use one texture and repeat it for a simple effect
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )
-- This bit is so the water draw right in the sampler or separately (sorry if this is confusing)
if( _G.sampleRoot ) then
	touchObj.fill = { type="image", filename=_G.sampleRoot.."water.png" }
else
	touchObj.fill = { type="image", filename="water.png" }
end
touchObj.fill.scaleX = 64/fullw
touchObj.fill.scaleY = 64/fullh
display.setDefault( "textureWrapX", "clampToEdge" ) -- set back to default
display.setDefault( "textureWrapY", "clampToEdge" ) -- set back to default


--
-- 4. Player object
local player = display.newImageRect( "player.png", 80, 80 )
player.x = centerX
player.y = centerY
player.yOffset = 35

--
-- 5. Touch dot object

local dot = display.newCircle( player.x, player.y + player.yOffset, 5 )
dot.strokeWidth = 3
dot:setStrokeColor( 1, 1, 0, 0.8)

--
-- 6. Player mover

player.moveSpeed = 1600 -- in pixels per second
player.toX = player.x
player.toY = player.y

local frames = 0
local skipFrame = 2
player.enterFrame = function( self )
	-- Kill listener and abort early if this object has been destroyed
	if( self.removeSelf == nil ) then 
		Runtime:removeEventListener( "enterFrame", self )
		return
	end

	-- Get the current time
	local curTime = getTimer()

	-- If we haven't started tracking tween time yet, mark time and abort early
	if( not self.lastTime ) then
		self.lastTime = curTime
		return
	end

	-- Skip ever other frame (otherwise transition won't work till we stop moving finger)
	frames = frames + 1
	if( frames % skipFrame ~= 0 ) then return end

	-- Calculate time since last enterFrame (dt) and store current time for next iteration
	local dt = curTime - self.lastTime
	self.lastTime = curTime

	-- If we don't need to move, just abort now.
	if( self.x == self.toX and self.y == self.toY ) then
		return
	end

	-- OK, we need to move, ....

	-- 1. Cancel any old transitions
	transition.cancel( self )

	-- 1. Calculate how long it will take to move to our target
	local vec = ssk.math2d.sub( self.x, self.y, self.toX, self.toY, true )
	local len = ssk.math2d.length( vec )
	local time = 1000 * len / self.moveSpeed

	-- 2. Start a transition
	transition.to( self, { x = self.toX, y = self.toY, time = time } )
	self.lastToX = self.toX
	self.lastToY = self.toY

end
Runtime:addEventListener( "enterFrame", player )


--
-- 7. Touch Listener (to update player's to X/Y )
touchObj.touch = function( self, event )
	player.toX = event.x
	player.toY = event.y - player.yOffset

	dot.x = event.x
	dot.y = event.y
	return true
end

touchObj:addEventListener( "touch" )



