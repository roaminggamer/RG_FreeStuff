-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

--[[		
--]]

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"Although the asker wanted to make a count-down timer, this example counts up.", 
	"A count down timer is similar, but I didn't want to deal with the end time",
	"logic, as well as explaining it.",
	"This principle behind storing the time is the same in either case", 
	"",
	"This example looks for a previously saved 'startTime' and loads it if found.", 
	"If none is found, it saves the 'current' time."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Load SSK
--require "ssk.loadSSK"

-- 2. Provide a place to store timer 'start' time.
-- 
local startTime = os.time()

-- 3. Check to see if there was a time saved already. If not, save one now.
--
if( io.exists( "bonusCountdown.txt" ) ) then
	-- Found an old saved time.  Load it
	startTime = io.readFile( "bonusCountdown.txt" )
	startTime = tonumber(startTime)

else
	-- Save current time to file.
	io.writeFile( startTime, "bonusCountdown.txt" )
end


-- 4. Create a basic timer to display the 'delta time'
--
local timerLabel = display.newText( "0:00.00", display.contentCenterX, display.contentCenterY, native.systemFont, 42 )

-- 5. User 'enterFrame' to update timer. (Costly as it executes every frame, but very accurate)
--
timerLabel.enterFrame = function( self )
	local curTime = os.time()
	local seconds = curTime - startTime

	local nHours = tonumber(string.format("%02.f", math.floor(seconds/3600)))
	local nMins = tonumber(string.format("%02.f", math.floor(seconds/60 - (nHours*60))))
	local nSecs = tonumber(string.format("%02.f", math.floor(seconds - nHours*3600 - nMins *60)))
	local nDays = 0

	
	while (nHours >= 24) do
		nDays = nDays + 1
		nHours = nHours - 24
	end
	timerLabel.text = string.format("%d days %d hours %2.2d minutes %2.2d seconds", nDays, nHours, nMins, nSecs )
end
Runtime:addEventListener( "enterFrame", timerLabel )


