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



local options =
{
    --array of tables representing each frame (required)
    frames =
    {
        -- Frame 1
        {
            --all parameters below are required for each frame
            x = 82,
            y = 1,
            width = 80,
            height = 110
        },
         
        -- Frame 2
        {
            x = 1,
            y = 1,
            width = 80,
            height = 110
        },
         
        -- Frame 3 and so on...
    },
 
    -- Optional parameters; used for scaled content support
    sheetContentWidth = 161,
    sheetContentHeight = 110
}

local imageSheet = graphics.newImageSheet( "images/leshy.png", options )


-- consecutive frames
local sequenceData =
{
    name="walking",
    start=1,
    count=2,
    time=750,
    loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
}


-- =============================================================
-- Forward Delcare Any LOCAL Functions We Need
-- These functions are used in the module, but not visible or 
-- in scope out of the module
-- =============================================================


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


	local character = display.newSprite( imageSheet, sequenceData )
	character.x = display.contentCenterX - 200
	character.y = display.contentCenterY
	character:play()
	transition.to( character, { x = character.x + 400, time = 8000, 
		onComplete = function( self ) self:pause() end } )

	layers.content:insert( character ) 	

	local back = display.newRect( layers.underlay, cx, cy, fullw, fullh )
	back:setFillColor( 0.2, 0.4, 0.8 )

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

end


function game.destroy( )
	-- Stop the game if it isn't stopped already
	game.stop()

	-- Destroy any layers (groups) that might have been made before
	display.remove( layers )
	layers = nil
end

-- =============================================================
-- Define any forward declared functions.
--
-- Tip: You could simply define them at the top of the file,
-- but I find that doing it this way is more flexible, and
-- I like to have my module.create() code close to to the top
-- of the file and not buried under a bunch of local functions.
-- =============================================================



-- return the module reference
return game