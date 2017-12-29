-- =============================================================
-- Your Copyright Statement Here
-- =============================================================

-- =============================================================
-- Require Needed Modules Here
-- =============================================================
local physics = require "physics"


-- =============================================================
-- Local Variables
-- =============================================================
local cx, cy = display.contentCenterX, display.contentCenterY
local fullw, fullh = display.actualContentWidth, display.actualContentHeight
local isRunning = false
local layers

-- =============================================================
-- Forward Delcare Any LOCAL Functions We Need
-- These functions are used in the module, but not visible or 
-- in scope out of the module
-- =============================================================
local dropBalls
local ballTimer 
local counter

-- =============================================================
-- Module Definition Begins
-- =============================================================
local game = {}

--==
--
--==
function game.create( group )

	-- 1. Call destroy first
	--
	-- This may seem weird, but it is nice
	-- later if we end up 're-creating' the game.  This will
	-- essentially ensure the game is cleaned up first.
	--
	game.destroy()

	-- 2. Create some rendering layers (groups) to nicely organinze our game world/
	--
	layers   			= display.newGroup()
	layers.underlay 	= display.newGroup()
	layers.content 	= display.newGroup()
	layers.overlay 	= display.newGroup()
	--
	group:insert( layers ) -- This group contains all layers
	layers:insert( layers.underlay ) -- Bottom layer.
	layers:insert( layers.content )  -- Middle layer
	layers:insert( layers.overlay )  -- Top layer

	-- 3. This sample uses physics so let's configure it.
	-- 
	physics.start()
	physics.setGravity(0,10)
	physics.setDrawMode('hybrid')

	-- 4. Now let's create a background for fun.
	--	
	local background = display.newRect( layers.underlay, cx, cy, fullw, fullh  )
	background:setFillColor( 0.2, 0.4, 0.8 ) 

	-- 5. Now let's create some world content.
	--
	-- In this case, just a single block for some balls to bounce off of
	local block = display.newRect( layers.content, cx - 100, cy + 200, 300, 40 )
	block:setFillColor( 0.25, 0.25, 0.25)
	block.rotation = 15
	physics.addBody( block, "static" )

	-- 6. Now lets create a counter 
	-- 
	counter = display.newText( layers.overlay, "0", cx, cy - fullh/2 + 50, native.systemFontBold, 48 )


	-- 7. Start the ball drop timer and call 'dropBalls' it forever every second.
	--
	ballTimer = timer.performWithDelay( 1000, dropBalls, -1 )
	
end

--==
--
--==
function game.start( )
	-- Game is already started, just exit
	if( isRunning ) then return end

	-- Mark game as running
	isRunning = true
end

--==
--
--==
function game.stop( )
	-- Game is already stopped, just exit
	if( not isRunning ) then return end

	-- Mark game as NOT running
	isRunning = false


	-- Stop the ball timer if it is running
	if( ballTimer ) then
		timer.cancel( ballTimer )
		ballTimer = nil
	end
end


function game.destroy( )
	-- Stop the game if it isn't stopped already
	game.stop()

	-- Destroy any layers (groups) that might have been made before
	display.remove( layers )
	layers = nil

	-- Clear any local references to objects we may have just deleted
	--
	counter = nil
end

-- =============================================================
-- Define any forward declared functions.
--
-- Tip: You could simply define them at the top of the file,
-- but I find that doing it this way is more flexible, and
-- I like to have my module.create() code close to to the top
-- of the file and not buried under a bunch of local functions.
-- =============================================================
function dropBalls()
	-- If game isn't running do nothing and exit
	if( not isRunning ) then return end

	-- Create a ball
	print("Drop a ball @ ", system.getTimer())
   local ball = display.newImageRect( layers.content, "images/circle.png", 40, 40 )
   ball.x = cx - math.random(50, 150)
   ball.y = cy - 200
   physics.addBody( ball, "dynamic", { radius = 18 } )

   -- Use a trick to delete it in 2 seconds
   timer.performWithDelay( ball, { delay = 2000, time = 0, alpha = 0, onComplete = display.remove } )

   -- Increment out counter to track how many balls have been dropped
   local count = tonumber(counter.text)
   counter.text = tostring( count + 1 )   
end



-- return the module reference
return game