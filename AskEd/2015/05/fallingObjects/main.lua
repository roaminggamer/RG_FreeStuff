-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted randomly drop objects from the top of the screen, ensuring", 
	"that they always started above the screen top.  This demo does that.",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 10 )
--physics.setDrawMode("hybrid")


-- Create the 'Ground'
--
local ground = display.newRect( display.contentCenterX,
                              display.contentCenterY + 200, display.actualContentWidth, 40  )
physics.addBody( ground, "static",{ friction = 0.5 } )
ground:setFillColor(0,1,0)


-- Random Dropper
--
local images = { "square.png", "yellow_round.png", "zombie_head.png" }
local function randomDropper()
	local image = images[math.random(1,#images)]
	
	local size = 40
	local fullw = display.actualContentWidth
	local fullh = display.actualContentHeight
	
	local obj = display.newImageRect( image, size, size )
	
	obj.x = display.contentCenterX + ( math.random( -fullw/2 + size/2, fullw/2 - size/2 ) )
	obj.y = display.contentCenterY - fullh/2 - size/2

	if( image == "square.png" ) then
		physics.addBody( obj, { friction = 0.5, bounce = 0.5 } )
	else
		physics.addBody( obj, { friction = 0.5, bounce = 0.5, radius = size/2 } )
	end

	transition.to( obj, { delay = 10000, time = 500, alpha = 0, onComplete = display.remove } )
end

-- Start dropping and run forever
--
timer.performWithDelay( 500, randomDropper, -1)
