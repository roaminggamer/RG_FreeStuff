-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who wrote this question wanted to create objects in one file (main.lua),",
	"and later manipulate them from another file (a module).",
	"",
	"This example shows a rudimentary way to do that safely, without using globals.", 
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Require our manipulator modules
local manipulator = require "manipulator"

--
-- 2. Create a table to hold our objects.
local myObjects = {}


--
-- 3. Register the table with the manipulator
manipulator.register( myObjects	)


-- 4. Create a bunch of objects and add them to the table. 
-- 
for i = 1, 50 do
	local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
	tmp.x = display.contentCenterX + math.random( -300, 300 )
	tmp.y = display.contentCenterY + math.random( -300, 300 )

	-- Store reference to object in table
	myObjects[tmp] = tmp

	-- Auto-destruct in 2 to 5 seconds
	tmp.timer = function( self )
		myObjects[self] = nil
		display.remove( self )
	end
	timer.performWithDelay( math.random( 2000, 5000 ), tmp )
end

-- 5. Start the manipulator running.
-- 
manipulator.start()
