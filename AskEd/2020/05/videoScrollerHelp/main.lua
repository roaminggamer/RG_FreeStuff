-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2020 (All Rights Reserved)
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- Variables for easy demo making
-- =============================================================
local centerX 	= display.contentCenterX
local centerY 	= display.contentCenterY
local fullw 	= display.actualContentWidth
local fullh		= display.actualContentHeight
local left 		= centerX - fullw/2
local right 	= left + fullw
local top 		= centerY - fullh/2
local bottom 	= top + fullh
--

-- Foward declare variables to ensure their visibility below.
local scroller
local video

-- Create 'fake' video object and capture y0 position.
video = display.newImageRect( "rg.png", 100, 100)
video.x = right - fullw/4
video.y = bottom - 50
video.y0 = video.y

-- Add enterFrame listener to update position of relative to scroller's view position change.
function video.enterFrame( self )
	local view = scroller:getView()
	local dy = view.y - view._y0
	video.y = video.y0 + dy
	-- print( view.y, view._y0, dy)
end

-- Wait at least 1 ms to start enterFrame listener (actually waits till next frame)
timer.performWithDelay( 1, function() Runtime:addEventListener( 'enterFrame', video ) end )


-- Create a dummy scroller with some content
local widget = require "widget"

local options = 
{
	x = centerX-fullw/4,
	y = centerY,
	width = fullw/2,
	height = fullh,
	backgroundColor = { 0.8, 0.8, 0.8 },
	hideScrollBar = true,
	listener = listener,
}

scroller = widget.newScrollView( options )

--
-- Important!  Capture the _y0 position of the view for user by the enterFrame listener above.
--
local view = scroller:getView()
view._y0 = view.y

-- Dummy content creation loop so we have something to scroll in this demo
local boxW = fullw/2
local boxH = fullh/4
for i = 1, 20 do
	local box = display.newRect( boxW/2, (i-0.5) * boxH, boxW-2, boxH-2 )
	scroller:insert(box)
	box:setFillColor(0.8, 0.5, 0.5)
	box:setStrokeColor(0)
	box.strokeWidth = 2
	box.label = display.newText( i, box.x, box.y, native.systemFont, 20 )
	box.label:setFillColor(0)
	scroller:insert(box.label)	
end