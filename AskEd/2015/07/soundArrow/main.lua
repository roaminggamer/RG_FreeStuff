-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who asked this question wanted to detect when an arrow was",
	" spinning and to play a sound at that time.", 
	"",
	"In this example: ",
	"1. The arrow tracks from frame to frame if has changed angle.",
	"2. If it detects a change it starts a looping sound.",
	"3. If it detects that it has stopped rotating, it stops the sound.",
	"4. Another indepent piece of code randomly spins/stops the arrow.",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Use physics for easy spinning
local physics = require "physics"
physics.start()
physics.setGravity(0,0)

--
-- 1. Create the arrow.
local arrow = display.newImageRect( "up.png", 80, 80 )
arrow.x = display.contentCenterX
arrow.y = display.contentCenterY + 100
physics.addBody( arrow )

-- Flags for our 'rotation' detection logic
arrow.lastAngle = arrow.rotation
arrow.isRotating = false

--
-- 2. Functions to start, stop sound
local channel
local sound = audio.loadSound( "woosh1.wav" )

print("sound", sound)
local function startSound()
	if( not sound ) then return end
	if( channel ) then return end
	channel = audio.findFreeChannel( 2 ) 
	if( not channel ) then return end
	local options = 
	{
		channel = channel,
		loops = -1,
	}
	audio.play( sound, options )
	print("Started sound!", system.getTimer() )
end

local function stopSound()
	if( not channel ) then return end
	audio.stop( channel )
	channel = nil
	print("Stopped sound!", system.getTimer() )
end

--
-- 3. Tell arrow to start checking for rotation start, stop
arrow.enterFrame = function( self )

	-- Detect angle change
	local deltaAngle = math.abs(self.rotation - self.lastAngle)
	local angleChanged = ( deltaAngle > 0.05 )

	-- Save current angle
	self.lastAngle = self.rotation

	-- See if this is a start or a stop of rotation
	if( angleChanged and not self.isRotating ) then
		self.isRotating = true
		startSound()
	
	elseif( self.isRotating  and not angleChanged ) then
		self.isRotating = false
		stopSound()
	end
end
Runtime:addEventListener( "enterFrame", arrow )


--
-- 4. Timer function to randoml spin or stop arro
local function onTimer()
	local doNothing = (math.random(1,100) > 50)
	if( doNothing ) then 
		return 
	end

	local stopIt = (math.random(1,100) > 50)
	if( stopIt ) then
		arrow.angularVelocity = 0
		return
	end

	arrow.angularVelocity = math.random( -180, 180 )
end

timer.performWithDelay( 250, onTimer, -1 ) -- Loop forever


