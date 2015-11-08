-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"This demonstrates a simple menu, with a title and two buttons.", 
	"",
	"1. Tap the buttons see what happens. (Look at console too.)",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Make a title
local myTitle = display.newText( "My Awesome Game", display.contentCenterX, 240, native.systemFont, 42 )

--
-- 2. Make a functional, but simple touch handler
local function onTouch( self, event )
	local id 	 = event.id
	local bounds = self.stageBounds

	if( event.phase == "began" ) then
		self.alpha = 0.5
		display.getCurrentStage():setFocus( self, id )
		self.isFocus = true


	elseif( self.isFocus ) then
		local x,y = event.x, event.y
		local isWithinBounds =  bounds.xMin <= x and bounds.xMax >= x and 
		                        bounds.yMin <= y and bounds.yMax >= y

		if( not isWithinBounds ) then
			self.alpha = 1
		else
			self.alpha = 0.5
		end

		if( event.phase == "ended" ) then
			self.alpha = 1
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
			if( self.callback ) then
				self.callback()
			end
		end
	end
	return true
end

--
-- 3. Make two buttons

local playButton = display.newRect( display.contentCenterX, myTitle.y + 100, 200, 50 )
playButton:setFillColor(0,0.6,0)
playButton.label = display.newText( "Play", playButton.x, playButton.y , native.systemFont, 22 )

playButton.callback = function()
	print("Play Game!")
end

playButton.touch = onTouch
playButton:addEventListener( "touch" )


local twirlButton = display.newRect( display.contentCenterX, playButton.y + 80, 200, 50 )
twirlButton:setFillColor(0, 0, 0.6)
twirlButton.label = display.newText( "Twirl Title", twirlButton.x, twirlButton.y , native.systemFont, 22 )

twirlButton.callback = function()
	print("Twirling Title!")
	transition.cancel( myTitle )
	myTitle.rotation = -360
	transition.to( myTitle, { rotation = 0, time = 3000, transition = easing.outBounce })
end

twirlButton.touch = onTouch
twirlButton:addEventListener( "touch" )

