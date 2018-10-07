io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2



local monkeyData    = require("monkey")
local monkeySheet = graphics.newImageSheet( "monkey.png", monkeyData:getSheet() )

local monkeySeqData =
{
	{
		name 			= "dancing",
		start 		= 1,
		count 		= 38,
   	time 			= 2000,
    	loopCount 	= 0, 
    	loopDirection = "bounce" 
   },
}

local function showMonkey( group, x, y )
	group = group or display.currentStage
	local monkey = display.newSprite( monkeySheet, monkeySeqData )
	group:insert(monkey)
	monkey.x = x or centerX
	monkey.y = y or centerY
	monkey:play()
	return monkey
end

-- Sprite in a container
local container = display.newContainer( 220, 220 ) 
container.x = cx
container.y = cy - 150
showMonkey( container, 0, 0 )
display.newText( "Normal", container.x, container.y + 130)

-- Sprites in containers w/ Textures/Images Over Top
local container = display.newContainer( 220, 220 ) 
container.x = cx - 300
container.y = cy - 150
showMonkey( container, 0, 0 )
local img = display.newImageRect( container, "rg256.png", 200, 200 )
display.newText( "Image Over #1", container.x, container.y + 130)
--
local container = display.newContainer( 220, 220 ) 
container.x = cx - 300
container.y = cy + 150
showMonkey( container, 0, 0 )
local img = display.newImageRect( container, "corona256.png", 200, 200 )
display.newText( "Image Over #2", container.x, container.y + 130)

-- Sprites in containers w/ Textures/Images Over Top + Blend Modes
local container = display.newContainer( 220, 220 ) 
container.x = cx + 300
container.y = cy - 150
showMonkey( container, 0, 0 )
local img = display.newImageRect( container, "rg256.png", 200, 200 )
img.blendMode = "add"
display.newText( "Blend Mode == 'add'", container.x, container.y + 130)
--
local container = display.newContainer( 220, 220 ) 
container.x = cx + 300
container.y = cy + 150
showMonkey( container, 0, 0 )
local img = display.newImageRect( container, "rg256.png", 200, 200 )
img.blendMode = "multiply"
display.newText( "Blend Mode == 'multiply'", container.x, container.y + 130)

-- Sprite in Masked Group
local group = display.newGroup()
group.x = cx
group.y = cy + 150
showMonkey( group, 0, 0 )
display.newText( "Masked Group", group.x, group.y + 130)
local mask = graphics.newMask( "mask.png" )
group:setMask(mask)