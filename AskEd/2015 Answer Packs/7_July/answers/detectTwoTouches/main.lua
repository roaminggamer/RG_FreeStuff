-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"1. Tap one of the objects (red or green).", 
	"2. Tap any place on the screen (execept on the objects).",
	"3. The object will move to that position over 1 second."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Load SSK
--require "ssk.loadSSK"

--
-- 2. Create a variable to track last tapped object.
local lastTapped

--
-- 3. Create a touch listener for the two objects
local onTouch = function( self, event )
	if( event.phase == "ended" ) then
		lastTapped = self
	end
	return true
end

--
-- 4. Create two objects
local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
tmp.x = display.contentCenterX - 100
tmp.y = display.contentCenterY
tmp:setFillColor(1,0,0)
tmp.touch = onTouch
tmp:addEventListener( "touch" )

local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
tmp.x = display.contentCenterX 
tmp.y = display.contentCenterY
tmp:setFillColor(0,1,0)
tmp.touch = onTouch
tmp:addEventListener( "touch" )

-- 
-- 5. A Runtime touch listener to do the moving
local function onMoveTouch( event )
	if( event.phase == "began" ) then
		if( lastTapped ) then 
			transition.to( lastTapped, { x = event.x, y = event.y, time = 1000 } )
			lastTapped = nil
		end
	end
	return true
end

Runtime:addEventListener( "touch", onMoveTouch )