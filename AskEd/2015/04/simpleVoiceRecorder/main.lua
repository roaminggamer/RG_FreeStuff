-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"This person wanted to see an implementation for a simple recorder.", 
	"This example allows you to record and play back samples.",
	"Recordings are stored in numbered files in the temporary folder."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Make a title
local myTitle = display.newText( "My Simple Voice Recorder", display.contentCenterX, 200, native.systemFont, 42 )


--
-- 2. Make a functional, but simple touch handler used by all buttons below
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
-- 3. Foward Delcare Functions and Variables Used Below
local lastRecordingNum = 0
local timerLabel
local recHandle 
local lastY
local createPlayButton

--
-- 4. Create Record Button and Timer Label
local recordButton = display.newRect( display.contentCenterX, myTitle.y + 100, 400, 50 )
recordButton:setFillColor(0,0.6,0)
recordButton.label = display.newText( "Record", recordButton.x, recordButton.y , native.systemFont, 22 )

recordButton.callback = function()

	-- Incmrent recording label number to store unique file
	lastRecordingNum = lastRecordingNum + 1
	local filePath = system.pathForFile( "myRecording" .. lastRecordingNum .. ".wav", system.TemporaryDirectory )
	-- Prep the recording
	recHandle = media.newRecording( filePath )	
	-- Optionally set sample rate
	--recHandle:setSampleRate(22050)
	-- Start recording
	recHandle:startRecording( )
	-- Start the timer
	timerLabel.startTime 	= system.getTimer()
	timerLabel.running = true

end
recordButton.touch = onTouch
recordButton:addEventListener( "touch" )

timerLabel = display.newText( "0.0", 
	                          recordButton.x + recordButton.contentWidth/2 + 20, 
	                          recordButton.y,
	                          native.systemFont, 32 )
timerLabel.anchorX 		= 0
timerLabel.startTime 	= system.getTimer()
timerLabel.running 		= false

timerLabel.enterFrame = function( self )	
	if( not self.running ) then return end
	local curTime = system.getTimer()
	local dt = curTime - self.startTime
	self.text = string.format("%2.1f", dt/1000 )
end
Runtime:addEventListener("enterFrame", timerLabel)


--
-- 4. Create Stop Recording Button
local stopButton = display.newRect( display.contentCenterX, recordButton.y + 60, 400, 50 )
stopButton:setFillColor(0.6, 0, 0)
stopButton.label = display.newText( "Stop", stopButton.x, stopButton.y , native.systemFont, 22 )
lastY = stopButton.y + 60

stopButton.callback = function()
	-- Stop the recording
	recHandle:stopRecording( )
	-- Get duration of recording and reset label	
	timerLabel.running = false
	local duration = timerLabel.text
	timerLabel.text = "0.0"
	-- Create a new 'play button'
	createPlayButton( "myRecording" .. lastRecordingNum .. ".wav", duration )
end
stopButton.touch = onTouch
stopButton:addEventListener( "touch" )

--
-- 5. Play Button Builder
createPlayButton = function( fileName, duration )
	local tmp = display.newRect( display.contentCenterX, lastY, 400, 50 )
	tmp:setFillColor(0, 0, 0.6)
	tmp.label = display.newText( fileName .. " - " .. tostring(duration) .. " seconds", 
		                         tmp.x, tmp.y , native.systemFont, 18 )
	-- Play sound when button is pressed
	tmp.callback = function()
		media.playSound( fileName, system.TemporaryDirectory )	
	end
	tmp.touch = onTouch
	tmp:addEventListener( "touch" )

	lastY = lastY + 60
end
