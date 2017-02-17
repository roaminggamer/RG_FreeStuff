io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local top = display.contentCenterY - display.actualContentHeight/2
local bottom = top + display.actualContentHeight
local left = display.contentCenterX - display.actualContentWidth/2
local right = left + display.actualContentWidth

local allBalloons = {}

local timerHandle

local physics = require("physics")
physics.start()
physics.setGravity(0,9.8)
--physics.setDrawMode( "hybrid" )

local function onTouch( self, event )
	allBalloons[self] = nil
	display.remove(self)
	return true
end

-- This function stops the game
local function endGame()
	
	-- Stop the timer
	timer.cancel(timerHandle)

	-- Iterate over 'allBalloons' table and destroy all balloons
	for k,v in pairs( allBalloons ) do
		display.remove(v)
	end

	display.newText( "Game Over", display.contentCenterX, display.contentCenterY, native.systemFont, 40 )

end

-- Generic/Common enterFrame listener used by each balloon
local function enterFrame( self )
	-- End the Game if any balloon's CENTER falls below the bottom of the screen
	if( self.y >= bottom ) then
		endGame()		
	end
end

-- Generic/Common finalize event listener used by each balloon
local function finalize( self )
	Runtime:removeEventListener("enterFrame",self)
end



local function createBalloon( )

	-- Randomly create one of five balloon images
	local imgNum = math.random( 1, 5 )	
	local tmp = display.newImageRect( "balloon" .. imgNum .. ".png", 295/5, 482/5 )	

	-- Store reference to balloon object in allBalloons table
	allBalloons[tmp] = tmp

	-- Randomly place the balloon
	tmp.y = top-50
	tmp.x = math.random( left + 50, right - 50 )

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
	tmp.linearDamping = 2

	-- Self destruct in 5 seconds
	timer.performWithDelay( 5000,
		function()
			allBalloons[tmp] = nil
			display.remove( tmp )
		end )


	-- attach generic enterFrame listener and listen for it
	tmp.enterFrame = enterFrame
	Runtime:addEventListener("enterFrame", tmp)

	-- attach generic finalize listener and listen for it
	tmp.finalize = finalize
	tmp:addEventListener("finalize")


end

-- Create a new baloon every 1/2 second  forever
timerHandle = timer.performWithDelay( 500, createBalloon, -1  )


