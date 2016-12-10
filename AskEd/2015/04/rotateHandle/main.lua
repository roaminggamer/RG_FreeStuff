-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who asked this question seemed to be asking about a door handle.", 
	"",
	"Maybe not?  I don't know.  Tap the door knob to rotate it."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


-- 1. Create door handle
-- 
local handle = display.newImageRect( "handle.png", 500, 167 )
handle.x = display.contentCenterX
handle.y = display.contentCenterY
handle.anchorX = 90/500 -- Change the rotation axis!
handle:scale(0.5,0.5)


-- 2. Create pivot marker
-- 
local marker = display.newRect( handle.x, handle.y, 10, 10 )
marker:setFillColor(1,0,0)
marker.alpha = 0.25

-- 3. Add Door Touch Rotator
--
handle.touch = function( self, event )
	if( event.phase == "ended" ) then
		if( self.handleState == nil ) then
			self.handleState = "up"
			transition.to( self, { rotation = -90, time = 250, transition = easing.outBounce } )

		elseif( self.handleState == "down" ) then
			self.handleState = "up"
			transition.to( self, { rotation = -90, time = 500, transition = easing.outBounce } )
		
		else
			self.handleState = "down"
			transition.to( self, { rotation = 90, time = 500, transition = easing.outBounce } )
		end
	end
	return true
end
handle:addEventListener( "touch" )
