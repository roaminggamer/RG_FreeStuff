-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( {} )

local jumpTime = 300

local backImage = display.newImage("backImage.jpg", centerX, centerY )
backImage:scale(2,2)
backImage.rotation = 90

local oldStyleSpriteSheetData = require( "animFrog.frog").getSpriteSheetData()

local options =
{
	spriteSheetFrames = oldStyleSpriteSheetData.frames
}

local imageSheet = graphics.newImageSheet( "animFrog/frog.png", options )

local frogSequenceData = {
	{ 
		name = "normalRun",  --name of animation sequence
		start = 1,
		count = 6,
		time = jumpTime,  --optional, in milliseconds; if not supplied, the sprite is frame-based
		loopCount = 1,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
		loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
	}  --if defining more sequences, place a comma here and proceed to the next sequence sub-table	
}

local myFrog = display.newSprite( imageSheet, frogSequenceData )
myFrog.x = left + 50
myFrog.y = centerY
myFrog.x0 = myFrog.x
myFrog.y0 = myFrog.y

local ground = display.newRect( centerX, centerY + 38, fullw, 40)
ground:setFillColor(0,0.4,0)

local lastJump = system.getTimer()
local function onJump(event)
	local curTime = system.getTimer()
	if( (curTime - lastJump) < jumpTime ) then return end
	lastJump = curTime
	if( myFrog.x < (right - 50) ) then
		myFrog:play()
		transition.to( myFrog, {x = myFrog.x + 40, time = jumpTime-100, transition = transition.linear })
	end
end

local function onReset(event)
	myFrog.x = myFrog.x0
	myFrog.y = myFrog.y0
end

local tmpButton = ssk.easyIFC:presetPush( nil, "default", centerX- 60, bottom - 50, 100, 42, "Jump", onJump )
local tmpButton = ssk.easyIFC:presetPush( nil, "default", centerX + 60, bottom - 50, 100, 42, "Reset", onReset )



