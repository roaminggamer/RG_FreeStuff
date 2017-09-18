-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 
-- =============================================================


local checkmarkData    = require("checkmark")
local checkmarkSheet = graphics.newImageSheet( "checkmark.png", checkmarkData:getSheet() )

local checkmarkSeqData =
{
	{
		name 			= "go",
		start 		= 1,
		count 		= 38,
   	time 			= 2000,
    	loopCount 	= 0, 
   },
}


-- Create sprite, play 'idle'
local tmp = display.newSprite( checkmarkSheet, checkmarkSeqData )
tmp.x = display.contentCenterX
tmp.y = display.contentCenterY
tmp:setSequence( "rightwalk" )
tmp:play()

