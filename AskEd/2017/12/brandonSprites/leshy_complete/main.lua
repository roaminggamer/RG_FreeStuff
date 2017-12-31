-- =============================================================
-- Your Copyright Statement Here
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================

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

----[[ 
local character = display.newSprite( imageSheet, sequenceData )

character.x = display.contentCenterX - 200
character.y = display.contentCenterY

character:play()

transition.to( character, { x = character.x + 400, time = 8000, 
	onComplete = function( self ) self:pause() end } )
--]]

--[[
local character = display.newSprite( imageSheet, sequenceData )

character.xScale = -1

character.x = display.contentCenterX + 200
character.y = display.contentCenterY

character:play()

transition.to( character, { x = character.x - 400, time = 8000, 
	onComplete = function( self ) self:pause() end } )
--]]

