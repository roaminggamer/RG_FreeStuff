-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"1. Tap one of the objects (red or green).", 
	"2. Tap any place on the screen (execept on the objects).",
	"3. The object will move to that position over 1 second."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Create text to hide/show via linear swipe
local label = display.newText( "This text will be hidden and revealed via linear swipe.", 
	                           display.contentCenterX, display.contentCenterY, native.systemFont, 32 )

label.fill.effect = "filter.linearWipe"
label.fill.effect.direction = { 1, 0 }
label.fill.effect.smoothness = 1


--
-- 2. Hide and reveal functions
local doHide
local doReveal
local waitTime 	= 500
local swipeTime = 2000

doHide = function( effect )
	effect.progress = 1
	transition.to( effect, { progress = 0, delay = waitTime, time = swipeTime, onComplete = doShow })
end

doShow = function( effect )
	effect.progress = 0
	transition.to( effect, { progress = 1, delay = waitTime, time = swipeTime, onComplete = doHide } )
end

--
-- 3. Start up the sequence (runs forever)
doHide( label.fill.effect )