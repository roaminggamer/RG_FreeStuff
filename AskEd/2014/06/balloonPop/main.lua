io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local allBalloons = {}

local physics = require("physics")
physics.start()
physics.setGravity(0,9.8)
--physics.setDrawMode( "hybrid" )

local function onTouch( self, event )
	allBalloons[self] = nil
	display.remove(self)
	return true
end

local function createBalloon( )

	-- Randomly create one of five balloon images
	local imgNum = math.random( 1, 5 )	
	local tmp = display.newImageRect( "balloon" .. imgNum .. ".png", 295/5, 482/5 )	

	-- Randomly place the balloon
	tmp.y = -50
	tmp.x = math.random( 50, 430 )

	-- Scale it to make a 'smaller' balloon
	--tmp:scale( 0.1, 0.1 )

	-- add a touch listener
	tmp.touch = onTouch
	tmp:addEventListener( "touch" )

	-- Give it a body so 'gravity' can pull on it
	physics.addBody( tmp, { radius = tmp.contentWidth/2} )

	-- Give the body a random rotation
	tmp.angularVelocity = math.random( -180, 180 )

	-- Give it drag so it doesn't accelerate too fast
	tmp.linearDamping = 1

	-- Self destruct in 5 seconds
	timer.performWithDelay( 5000,
		function()
			allBalloons[tmp] = nil
			display.remove( tmp )
		end )
end


-- Create a new baloon every 1/2 second  forever
timer.performWithDelay( 500, createBalloon, -1  )