-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"This person wanted to create a click-able door handle animation.", 
	"",
	"No problem!  Just use transitions."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


-- Create door handle
-- 
local handle = display.newImageRect( "handle.png", 500, 167 )
handle.x = display.contentCenterX
handle.y = display.contentCenterY
handle.anchorX = 90/500 -- Change the rotation axis!
handle:scale(0.5,0.5)

--Create pivot marker
-- 
local marker = display.newRect( handle.x, handle.y, 10, 10 )
marker:setFillColor(1,0,0)
marker.alpha = 0.25

-- Add Door Touch Rotator
--
handle.touch = function( self, event )
	if( event.phase == "ended" ) then
		transition.to( self, { rotation = 90, time = 150, transition = easing.outBounce } )
		transition.to( self, { rotation = 0, delay = 150, time = 250, transition = easing.outBounce } )
	end
	return true
end
handle:addEventListener( "touch" )
