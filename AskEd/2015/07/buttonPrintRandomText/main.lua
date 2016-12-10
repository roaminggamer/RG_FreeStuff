-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted to print random strings when pressing a button.",
	"To simplify things, I'm treating the whole screen as the button.", 
	"",
	"1. Tap the screen and the example will select a random phrase from a table.",
	"2. It will then change the label in the middle of the screen to display",
	"that phrase and it's number in the table."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Load SSK
--require "ssk.loadSSK"

--
-- 1. Prases to choose from
local phrases = {
	"Corona",
	"Roaming Gamer",
	"Games", 
	"Apps", 
	"Have Fun!"	
}

--
-- 2. Create a label for showing the phrases
local phraseLabel = display.newText( "", display.contentCenterX, display.contentCenterY, native.systemFont, 32 )


-- 3. A Runtime touch listener to do select and show the message
-- 
local function onMoveTouch( event )
	if( event.phase == "began" ) then
		local phraseNum = math.random(1, #phrases)
		phraseLabel.text = "#" .. phraseNum .. " - " .. phrases[phraseNum]
	end
	return true
end

Runtime:addEventListener( "touch", onMoveTouch )