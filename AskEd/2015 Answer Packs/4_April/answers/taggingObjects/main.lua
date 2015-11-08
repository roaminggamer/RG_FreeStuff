-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"This demonstrates how to use a common (single) listener on objects, and", 
	"to extract a 'tag' from any touched object.",
	"",
	"1. Tap the buttons see what happens. (Look at console too.)",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Load SSK
--require "ssk.loadSSK"

--
-- 2. Make a title
local messageLabel = display.newText( "Tap A Button Please", display.contentCenterX, 240, native.systemFont, 42 )

--
-- 3. This is a very basic listener that shows the current button's tag in the messageLabel
local function onTouch( self, event )
	if( event.phase == "began" ) then
		messageLabel.text = "Touched: " .. tostring( self.myTag )
	end
	return true
end

--
-- 4. A button builder
local function newButton( x, y, width, height, tag )
	local tmp = display.newRect( x, y, width - 10, height - 5 )
	tmp:setFillColor(0.2, 0.2, 0.2)
	tmp.label = display.newText( tag, x, y, native.systemFont, 22 )

	tmp.myTag = tag	

	tmp.touch = onTouch
	tmp:addEventListener( "touch" )
end

--
-- 5. Create a bunch of buttons
local buttonWidth  = 80
local buttonHeight = 30
local startX = display.contentCenterX - ( 5 * buttonWidth )/2 + buttonWidth/2
curX = startX
local curY = messageLabel.y + 100
local count = 0
for i = 1, 3 do
	curX = startX
	for j = 1, 5 do
		count = count + 1
		newButton( curX, curY, buttonWidth, buttonHeight, count )
		curX = curX + buttonWidth
	end
	curY = curY + buttonHeight
end


