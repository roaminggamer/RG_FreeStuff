-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who asked this question wanted to be able to drag objects around, ",
	"but also wanted the drag to be blocked if the object encountered another object",
	"that was in the way.",
	"",
	"1. Drag the green object around the free space.", 
	"2. Try to drag the green object through the red object."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end



--
-- 1. Require and start physics
local physics 		= require "physics"
physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode( "hybrid" ) -- Shows the dragging mechanic nicely


--
-- 2. Require a helper library for physics dragging
local helpers = require "helpers"


-- 
-- 3. Creat a draggable block
local block = display.newRect( 0, 0, 120, 80 )
block.x = display.contentCenterX
block.y = display.contentCenterY 
block:setFillColor( 1, 1, 0 )
physics.addBody( block , "dynamic", { density = 1, friction = 0.5 } )
block.linearDamping = 1
block.angularDamping = 1
block.isSleepingAllowed = false
helpers.addDragger( block )


-- 
-- 4. Create a static block for our 'drag blocking' test.
local block = display.newRect( 0, 0, 120, 80 )
block.x = display.contentCenterX
block.y = display.contentCenterY + 100
block:setFillColor( 1, 0, 0 )
physics.addBody( block , "static")

