-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================


display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who asked this question wanted to have one non-physics",
	"object follow another physics object and to maintain a fixed relative position.", 
	"",
	"In this example, a 'sign' is attached to a falling object.  It tracks the object's",
	"position and displays it while staying directly above the  falling object."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Require and start physics
local physics = require "physics"
physics.start()
physics.setGravity(0,2)
--physics.setDrawMode( "hybrid" ) -- uncomment for debug rendering

--
-- 2. Function to attach a 'tracking' sign to an object
local function addSign( obj )

	-- Create a group and a sign inside the group
	local signGroup = display.newGroup()
	signGroup.x = obj.x 
	signGroup.t = obj.y - 40

	-- Create the sign and make it show the object's position
	local sign = display.newRect( signGroup, 0, 0, 100, 30)
	local label = display.newText( signGroup, "", 0, 0, native.systemFont, 16 )
	label:setFillColor(0,0, 0)

	-- Make the sign follow the object and update its label
	-- To show the objects <x,y> position
	signGroup.enterFrame = function( self )
		-- Is the object still valid?
		if( obj.removeSelf == nil ) then
			-- Nope
			Runtime:removeEventListener( "enterFrame", self )
			display.remove(self)
			return
		end

		self.x = obj.x 
		self.y = obj.y - 40

		local x = math.floor(obj.x+0.5)
		local y = math.floor(obj.y+0.5)
		label.text = "< " .. x .. ", " .. y .. " >"
	end
	Runtime:addEventListener( "enterFrame", signGroup )
end

--
-- 3. Define functions to spawn face objects
local function spawnFace( x, y )
	local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
	tmp.x = x
	tmp.y = y

	addSign( tmp )

	physics.addBody( tmp, "dynamic", { radius = 20, bounce = 0.5 })

	timer.performWithDelay( 3000, function() spawnFace( x, y ) end ) -- spawn new object in 3 seconds

	timer.performWithDelay( 10000, function() display.remove(tmp) end ) -- destroy object in 10 seconds
end


--
-- 4. Draw a ground
for i = 1, 24 do
	local tmp = display.newImageRect( "square.png", 40, 40 )
	tmp.x = 40 * i - 20
	tmp.y = display.contentCenterY + 200
	physics.addBody( tmp, "static" )
end

local tmp = display.newImageRect( "square.png", 40, 40 )
tmp.x = 20
tmp.y = display.contentCenterY + 160
physics.addBody( tmp, "static" )

local tmp = display.newImageRect( "square.png", 40, 40 )
tmp.x = 40 * 24 - 20
tmp.y = display.contentCenterY + 160
physics.addBody( tmp, "static" )


-- 
-- 5. Start Dropping objects
spawnFace( display.contentCenterX - 180, display.contentCenterY + 25)
spawnFace( display.contentCenterX - 160, display.contentCenterY - 75 )
