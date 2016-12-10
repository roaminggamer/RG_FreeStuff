-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The asker wanted to make a marble tilt game.", 
	"1. Build for the device and install.",
	"2. Run this demo and tilt to navigate smiley to green hole.",
	"3. When you get close enought, the player will teleport back to the start."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--[[ Used for testing - ONLY uncomment if you have the reflector utility !!!
local reflector = require "RGEventReflector.reflector"
--local reflectorEvents = reflector.getReflectorEvents()
reflector.setReflectorEvents( { "accelerometer" } )

reflector.setUpdatePeriod( 60 )
reflector.printReflectorEvents()

if( oniOS or onAndroid ) then
	print("Sender")
	reflector.getIP()
	reflector.initSender( { receiverIP = "10.0.0.7" })
else
	print("Receiver")
	reflector.getIP()
	reflector.initReceiver()
end
--]]
	

--
-- Load SSK
--require "ssk.loadSSK"


-- Create Start Position and Goal Sensor
-- 
local startAt = display.newCircle( display.contentCenterX - 200, display.contentCenterY, 25 )
startAt:setFillColor(0,0,0,0)
startAt.strokeWidth = 2


local goal = display.newCircle( display.contentCenterX + 200, display.contentCenterY, 25 )
goal:setFillColor(0,0,0,0)
goal:setStrokeColor(0,1,0)
goal.strokeWidth = 2


-- 2. Create player with 'tilt movement code'
-- 
local player = display.newImageRect( "yellow_round.png", 40, 40 )
player.x = startAt.x
player.y = startAt.y

-- Stolen from Rob's example in Forums post (then modified)
local sensitivity = 2
local function onTilt(event)
    player.x = (player.x + event.xGravity * (sensitivity * 15 ) )
    player.y = (player.y - event.yGravity * (sensitivity * 15 ) )
    return true
end
Runtime:addEventListener("accelerometer", onTilt )
system.setAccelerometerInterval( 30 )


-- Add code to goal to move player back to start if player is 'close' to center of goal.
-- 
local minOffset = 10
goal.enterFrame = function( self )
	local dx = self.x - player.x
	local dy = self.y - player.y

	if( ( dx * dx + dy * dy ) <= minOffset * minOffset ) then
		player.x = startAt.x
		player.y = startAt.y
	end
end
Runtime:addEventListener("enterFrame", goal)
