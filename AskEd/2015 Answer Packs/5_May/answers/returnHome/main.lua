-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"This demonstrates how make objects return to their 'home' position after dragging.", 
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- Implement dragger with return home functionality
local function onDrag( self, event )
	local id = event.id
	if( event.phase == "began" ) then
		self.x1 = self.x
		self.y1 = self.y
		display.getCurrentStage():setFocus( self, id )
		self.isFocus = true
		return true

	elseif( self.isFocus ) then
		if( event.phase == "moved" ) then
			self.x = self.x1 + event.x - event.xStart
			self.y = self.y1 + event.y - event.yStart
		
		elseif( event.phase == "ended" ) then
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
			transition.to( self, { x = self.x0, y = self.y0, time = 250 } )
		end
		return true
	end
	return false
end


-- Create two objects for dragging, using the two different draggers`
-- 
local tmp = display.newImageRect( "yellow_round.png", 80, 80 )
tmp.x = display.contentCenterX
tmp.y = display.contentCenterY - 40
tmp.x0 = tmp.x
tmp.y0 = tmp.y
tmp:setFillColor(1,0,0)
tmp.touch = onDrag
tmp:addEventListener( "touch" )

local tmp = display.newImageRect( "yellow_round.png", 80, 80 )
tmp.x = display.contentCenterX 
tmp.y = display.contentCenterY + 120
tmp.x0 = tmp.x
tmp.y0 = tmp.y
tmp:setFillColor(0,1,0)
tmp.touch = onDrag
tmp:addEventListener( "touch" )

