-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who asked this question wanted to play with sounds.",
	"He got an answer and the answer was this article:",
	"http://coronalabs.com/blog/2011/07/27/the-secretundocumented-audio-apis-in-corona-sdk/",
	"",
	"This example shows normal, high, and low pitched sound using the 'secret API'.",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Create a simple button listener
local onTouch = function( self, event )
	if( event.phase == "ended" ) then
		self.myCallback()
	end
	return true
end

--
-- 2. Various sound functions
local function normal()
	local sound = audio.loadSound( "bark.wav" )
	local options = { channel = audio.findFreeChannel() , loops = 2 }
	audio.play( sound, options )
end

local function highPitch()
	local sound = audio.loadSound( "bark.wav" )
	local options = { channel = audio.findFreeChannel() , loops = 2 }
	local _, source = audio.play( sound, options )
	al.Source( source, al.PITCH, 1.5 )
end

local function lowPitch()
	local sound = audio.loadSound( "bark.wav" )
	local options = { channel = audio.findFreeChannel() , loops = 2 }
	local _, source = audio.play( sound, options )
	al.Source( source, al.PITCH, 0.75 )
end

local function readArticle()
	system.openURL( "http://coronalabs.com/blog/2011/07/27/the-secretundocumented-audio-apis-in-corona-sdk/" )
end

--normal()
--highPitch()
--lowPitch()


--
-- 3. Make buttons to play sounds
local buttonNames 		= { "Normal", "High Pitched", "Low Pitched", "Read Article" }
local buttonCallbacks	= { normal, highPitch, lowPitch, readArticle }

local currentY = display.contentCenterY - 100 
for i = 1, #buttonNames do

		local button = display.newRect( 0, 0, 300, 30 )
		button.x = display.contentCenterX
		button.y = currentY
		button:setFillColor( 0.2, 0.2, 0.2 )
		button.touch = onTouch
		button:addEventListener("touch")
		button.myCallback = buttonCallbacks[i]
		currentY = currentY + 50

		display.newText( buttonNames[i], button.x, button.y , native.systemFont, 22 )
end
